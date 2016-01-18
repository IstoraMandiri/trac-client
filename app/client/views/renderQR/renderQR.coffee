Template.renderQR.onRendered ->
  @$('.qr-code').qrcode text: @data.toString()