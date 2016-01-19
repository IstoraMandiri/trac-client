BlazeLayout.setRoot 'body'

# index
FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'defaultLayout',
      header: 'header'
      main: 'landingPage'
      footer: 'footer'

# serial registration
FlowRouter.route '/serial/:serial',
  action: ->
    BlazeLayout.render 'defaultLayout',
      header: 'header'
      main: 'serialRegistration'
      footer: 'footer'
