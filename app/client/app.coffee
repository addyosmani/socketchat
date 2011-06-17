exports.init = ->
  if SS.client.browser.isSupported()
    $('.message.template').hide()
    SS.server.app.init (user) -> if user then $('#main').show() else displaySignInForm()
    $('form#sendMessage').submit ->
      newMessage = $('#newMessage').val()
      SS.server.app.sendMessage newMessage, (response) -> if response.error then alert(response.error) else $('#newMessage').val('')
      false

    SS.events.on 'newMessage', (params) ->
      addMessage params
      SS.client.scroll.down('#messages', 450)
  else
    SS.client.browser.showIncompatibleMessage()
  
displaySignInForm = ->
  $('#signIn').show().submit ->
    SS.server.app.signIn $('#signIn').find('input').val(), (response) ->
      $('#signInError').remove()
      if response is false
        $('#signIn').append("<p id='signInError'>The name you provided was incorrect. Sorry.</p>").find('input').val('')
      else
        $('#signIn').fadeOut 230
        $('#main').show()
    false

addMessage = (params) ->
  $('.message').clone().find('.body').html(params.body).parent().find('.user').html(params.cdid).parent().appendTo("#messages").show()