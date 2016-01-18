
# set the view of the container template so we can display the relevent view
Template.serialRegistration.onCreated ->
  # reactive view state
  @view = new ReactiveVar()
  # set serial variable; not reactive
  @serial = FlowRouter.getParam 'serial'
  # start off by hitting the ownership info url
  do @getOwnershipInfo = =>
    @view.set 'Loading'
    # ajax request
    $.get App.urls.getOwnershipInfo + @serial
    .error (err) =>
      @view.set 'ConnectionError'
    .success (data) =>
      # TODO: parse data for correct info
      console.log 'success', data, @

Template.serialRegistration.helpers
  serial: ->
    Template.instance().serial

  thisView: ->
    "serial" + Template.instance().view.get()

# reconnect event exposed to child templates
Template.serialRegistration.events
  'click .get-ownership-info' : ->
    Template.instance().getOwnershipInfo()