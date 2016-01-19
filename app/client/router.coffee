BlazeLayout.setRoot 'body'

# index
FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'defaultLayout',
      header: 'header'
      main: 'landingPage'
      footer: 'footer'

# TODO refactor these into routes

# registration
FlowRouter.route '/serial/:serial',
  action: ->
    BlazeLayout.render 'defaultLayout',
      header: 'header'
      main: 'serialRegistration'
      footer: 'footer'

# registration
FlowRouter.route '/transfer/:serial',
  action: ->
    BlazeLayout.render 'defaultLayout',
      header: 'header'
      main: 'serialRegistration'
      footer: 'footer'
