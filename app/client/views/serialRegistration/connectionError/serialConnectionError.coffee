Template.serialConnectionError.events
  'click .try-again' : (e, tmpl) ->
    e.preventDefault()
    console.log Template.parentData(3)
    console.log 'trying...'