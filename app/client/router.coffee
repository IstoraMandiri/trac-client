# index
FlowRouter.route '/',
  action: ->
    BlazeLayout.render 'landingPageLayout',
      main: 'landingPage'
      footer: 'footer'

# serial registration
FlowRouter.route '/serial/:serial',
  action: ->
    BlazeLayout.render 'serialRegistrationLayout',
      main: 'serialRegistration'
      footer: 'footer'
