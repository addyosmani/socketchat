# Client-side code

# This function is called automatically once the websocket is setup
exports.init = ->
  $('.message.template').hide()
  SS.server.app.init (user) ->
    if user then $('#main').show() else displaySignInForm()
    
  # Bind to Submit button
  $('form#sendMessage').submit ->
    newMessage = $('#newMessage').val()
    SS.server.app.sendMessage newMessage, (response) ->
      if response.error then alert(response.error) else $('#newMessage').val('')
    false
    
  # Bind to new incoming message event
  SS.events.on 'newMessage', renderMessage


# PRIVATE
 
# Display the user sign-in form
displaySignInForm = ->
  $('#signIn').show().submit ->
    SS.server.app.signIn $('#signIn').find('input').val(), (response) ->
      $('#signInError').remove()
      displayMainScreen()
    false
    
displayMainScreen = ->
  $('#signIn').fadeOut(230) and $('#main').show()

renderMessage = (params) ->
  $('#templates-message').tmpl(params).appendTo('#messages')
  SS.client.scroll.down('#messages', 450)
