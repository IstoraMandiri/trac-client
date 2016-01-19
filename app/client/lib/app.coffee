@App = @App || {}

txServerUrl = Meteor.settings.public.txServerUrl

App.urls =
  getOwnershipInfo: txServerUrl + "ownership/"
  registerSerial: txServerUrl + "ownership/"
  getTxInfo: txServerUrl + "tx/"
  clientUrl: Meteor.settings.public.clientUrl

App.pollInterval = 2000