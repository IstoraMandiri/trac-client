
# set the view of the container template so we can display the relevent view
Template.serialRegistration.onCreated ->
  # reactive view state and data
  @view = new ReactiveVar()
  @templateData = new ReactiveVar()
  # set serial variable; not reactive
  @serial = FlowRouter.getParam 'serial'
  # start off by hitting the ownership info url
  do @getOwnershipInfo = =>
    @view.set 'Loading'
    @templateData.set null

    # DEV
    # @view.set 'Unclaimed'
    # @templateData.set address: 'xyz'

    $.get App.urls.getOwnershipInfo + @serial
    .error (err) =>
      # couldn't connect
      @view.set 'ConnectionError'
    .success (data) =>
      console.log 'got data', data
      if data.address
        @view.set 'Claimed'
        @templateData.set address: data.address
      else
        @view.set 'Unclaimed'

Template.serialRegistration.helpers
  serial: ->
    Template.instance().serial
  view: ->
    "serial" + Template.instance().view.get()
  data: ->
    Template.instance().templateData.get()

# reconnect event exposed to child templates
Template.serialRegistration.events
  'click .get-ownership-info' : ->
    Template.instance().getOwnershipInfo()