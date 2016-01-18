@App = @App || {}

txServerUrl = Meteor.settings.public.txServerUrl

App.urls =
  getOwnershipInfo: txServerUrl + "ownership/"
  registerSerial: txServerUrl + "ownership/"
  getTxInfo: txServerUrl + "tx/"