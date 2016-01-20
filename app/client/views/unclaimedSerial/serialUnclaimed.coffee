# set the view of the container template so we can display the relevent view
Template.serialUnclaimed.onCreated ->
  # reactive view state and data
  @view = new ReactiveVar 'Prompting'
  @templateData = new ReactiveVar null

Template.serialUnclaimed.helpers
  view: -> "serialUnclaimed" + Template.instance().view.get()
  data: -> Template.instance().templateData.get()
  cardColor: ->
    # TODO dynamic color
    thisView = Template.instance().view.get()
    if thisView is 'Prompting'
      'light-blue darken-2 white-text'
    else if thisView is 'Error'
      'pink darken-3 white-text'
    else if thisView is 'Registered'
      'light-green accent-2'
    else
      'grey lighten-4'


# passed to child templates
Template.serialUnclaimed.events
  'click .retry-registration' : (e, tmpl) ->
    tmpl.view.set 'Prompting'

  'click .register-serial' : (e, tmpl) ->

    # generate the keys
    addressKey = randomBytes 32
    address = "0x" + ethUtils.privateToAddress(addressKey).toString('hex')

    # crate a sharing secret
    transferKey = randomBytes 32
    secretHash = ethUtils.sha256(transferKey).toString('hex')

    # update the UI
    tmpl.view.set 'Posting'

    # TODO also generate a secret
    postData =
      serial: tmpl.data.serial
      address: address
      secret: secretHash

    # DEV
    # tmpl.view.set 'Registered'
    # tmpl.templateData.set blockNumber: 'block number here'

    $.ajax
      type: "POST"
      url: App.urls.registerSerial
      contentType: "application/json"
      data: JSON.stringify postData

    .fail (err) =>
      tmpl.view.set 'Error'

    .success (data) =>
      tmpl.templateData.set
        txHash: data.txHash
        address: address
        addressKey: addressKey.toString('hex')
        transferKey: transferKey.toString('hex')
        serial: tmpl.data.serial

        # also pass parent vars updating
        parentView: tmpl.view
        parentTemplateData: tmpl.templateData

      tmpl.view.set 'Polling'

# Track the transaction by polling
Template.serialUnclaimedPolling.onCreated ->
  txHash = @data.txHash
  @error = new ReactiveVar false
  attempts = 0
  do poll = =>
    retry = ->
      # TODO maximum attempts?
      attempts++
      Meteor.setTimeout ->
        poll()
      , App.pollInterval

    # make the request
    $.ajax
      type: 'GET'
      cache: false
      url: App.urls.getTxInfo + txHash
    .fail (err) =>
      # TODO something special if the TX is rejected
      @error.set 'Connection Error. Retrying...'
      retry()
    .success (data) =>
      @error.set false
      if data.state is 'accepted'
        @data.parentView.set 'Registered'
        @data.parentTemplateData.set
          address: @data.address
          addressKey: @data.addressKey
          transferKey: @data.transferKey
          serial: @data.serial
          txData: data.txData
      else
        # TODO something special if the TX is rejected
        retry()

Template.serialUnclaimedPolling.helpers
  error: ->
    Template.instance().error.get()

Template.serialUnclaimedRegistered.helpers
  downloadKeysUri : ->
    # TODO polyfill
    base64Data = btoa """
    Verify URL:
    #{App.urls.clientUrl}serial/#{@serial}

    Transfer URL:
    #{App.urls.clientUrl}transfer/#{@serial}?p=#{@transferKey}

    Serial:
    #{@serial}

    Address:
    #{@address}

    Address Private Key:
    #{@addressKey}

    Transfer Private Key:
    #{@transferKey}
    """
    return "data:text/plain;base64," + base64Data

  transferUrl: ->
    "#{App.urls.clientUrl}transfer/#{@serial}?p=#{@transferKey}"

