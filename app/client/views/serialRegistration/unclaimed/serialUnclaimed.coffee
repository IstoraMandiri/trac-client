# set the view of the container template so we can display the relevent view
Template.serialUnclaimed.onCreated ->
  # reactive view state and data
  @view = new ReactiveVar 'Prompting'
  @templateData = new ReactiveVar null
  # key info
  @keys = new ReactiveDict()

Template.serialUnclaimed.helpers
  view: -> "serialUnclaimed" + Template.instance().view.get()
  data: -> Template.instance().templateData.get()
  registering: -> Template.instance().view.get() isnt 'Prompting'
  publicKey: -> Template.instance().keys.get 'public'
  privateKey: -> Template.instance().keys.get 'private'

# passed to child templates
Template.serialUnclaimed.events
  'click .retry-registration' : (tmpl) ->
    tmpl.keys.set 'private', null
    tmpl.keys.set 'public', null
    tmpl.view.set 'Prompting'

  'click .register-serial' : (e, tmpl) ->
    # generate the keys
    privateKey = randombytes 32
    publicKey = secp256k1.publicKeyCreate(privateKey).toString('hex')
    # update the UI
    tmpl.keys.set 'private', privateKey.toString('hex')
    tmpl.keys.set 'public', publicKey
    tmpl.view.set 'Posting'
    # post data to txServer
    $.post App.urls.registerSerial,
      data:
        serial: @serial
        address: publicKey
    .fail (err) =>
      templ.view.set 'Error'
    .success (data) =>
      tmpl.templateData.set
        txHash: data.txHash
        # also pass parent vars updating
        parentView: tmpl.view
        parentTemplateData: tmpl.templateData
      tmpl.view.set 'Polling'

# Track the transaction by polling
Template.serialUnclaimedPolling.onCreated ->
  txHash = @data.txHash
  console.log @data
  @error = new ReactiveVar false
  attemps = 0
  do poll = =>
    retry = ->
      # TODO maximum attempts?
      attempts++
      Meteor.setTimeout ->
        poll()
      , App.pollInterval
    # make the request
    $.get App.urls.getTxInfo + txHash
    .fail (err) =>
      @error.set 'Connection Error. Retrying...'
      retry()
    .success (data) =>
      @error.set false
      if data.state is 'accepted'
        @data.parentView.set 'Registered'
        @data.parentTemplateData.set data.txData
      else
        retry()

Template.serialUnclaimedPolling.helpers
  error: ->
    Template.instance().error.get()
