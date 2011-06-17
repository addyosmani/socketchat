exports.init = -> if SS.client.browser.isSupported() then loadApp() else SS.client.browser.showIncompatibleMessage()

loadApp = ->
  $('.message.template').hide()
  SS.server.app.init (user) -> if user then $('#main').show() else displaySignInForm()
  $('form#sendMessage').submit ->
    newMessage = $('#newMessage').val()
    SS.server.app.sendMessage newMessage, (response) -> if response.error then alert(response.error) else $('#newMessage').val('')
    false
  SS.events.on 'newMessage', (params) -> renderMessage(params)
  
displaySignInForm = ->
  $('#signIn').show().submit ->
    SS.server.app.signIn $('#signIn').find('input').val(), (response) -> $('#signInError').remove() and if response is false then $('#signIn').append("<p id='signInError'>The name you provided was incorrect. Sorry.</p>").find('input').val('') else displayMainScreen()
    false
    
displayMainScreen = -> $('#signIn').fadeOut(230) and $('#main').show()

renderMessage = (params) -> $('.message').clone().find('.body').html(params.body).parent().find('.user').html(params.cdid).parent().appendTo("#messages").show() and SS.client.scroll.down('#messages', 450)