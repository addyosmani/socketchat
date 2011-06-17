# Store state info for the app
window.lounge =
  user:               {}
  infocus:            true
  new_message_count:  0

# This method is called automatically once the websocket connection is established
exports.init = ->
  lounge.title = window.document.title
  if SS.client.browser.isSupported()
    bindEvents()
    loadSession()
  else
    SS.client.browser.showIncompatibleMessage()
  
# Contacts the server to see if user has already signed in and loads their details. If not, display the signin form
loadSession = ->
  SS.server.app.init (user) ->
    if user then signUserIn(user) else displaySignInForm()
  
# Sign the user in and display the message window
signUserIn = (user) ->
  setUser user
  lounge.infocus = true
  $('#main').show()

# Store the user's data into app.user
setUser = (data) ->
  lounge.user = data
  $('#messages').data('scroll_height', $('#messages')[0].scrollHeight)
  SS.client.scroll.enable '#messages', 450

# Display a form asking for the user's username
displaySignInForm = ->
  $('#signIn').show().submit ->
    SS.server.app.signIn $('#signIn').find('input').val(), (response) ->
      $('#signInError').remove()
      if response is false
        $('#signIn').find('input').val('')
        $('#signIn').append("<p id='signInError'>The name you provided was incorrect. Sorry.</p>")
      else
        $('#signIn').fadeOut 230
        signUserIn response
    false

updatePeopleCount = ->
  count = Person.online().count()
  text = if count is 1 then '1 person online' else "#{count} people online"
  $('#peepsOnline').text text


addMessage = (params) ->
  params.body = params.body.htmlEncode()
  params.date = params.date.shortDate()
  messageTemplate.add params

# Setup models and jQuery callbacks
bindEvents = ->

  # SmartTemplate is an optional client-side library which handles the insertion of new elements in the DOM
  # https://github.com/paulbjensen/smartTemplate
  # You can find the code in /lib/client
  window.messageTemplate = new SmartTemplate 'message', bindDataToCssClasses: true, afterAdd: (object) -> 
    object.find('.body').html(SS.client.messageParser.parse object.find('.body').text()).fadeIn 450
  window.personTemplate  = new SmartTemplate 'person',  bindDataToCssClasses: true, afterAdd: (object) -> object.fadeIn 450

  # JS Model is an optional client-side library which allows you to work with models within JavaScript
  # http://benpickles.github.com/js-model/
  # You can find the code in /lib/client
  window.Person = new Model 'person', -> 
    @unique_key = "cdid"
    @include
      signIn: ->
        @attributes.online = true
        @attributes.id = @attributes.cdid     # set the id attribute to the cdid, helps to identify the instance.
        personTemplate.add @attributes if $("#person_#{@attributes.id}").length is 0 # add it unless it's already on the page
        updatePeopleCount()
        SS.client.scroll.down('#people', 350)
      signOut: ->
        @attributes.online = false
        personTemplate.remove @attributes.cdid
        updatePeopleCount()
        SS.client.scroll.down('#people', 350)
    @extend
      online: ->
        @select -> @attr('online') == true
  
  # When a new person is added, call the signIn() function defined above
  Person.bind "add", (newObject) ->
    newObject.signIn() unless newObject.attributes.doNotSignIn is true
    

  # Make the send button work  
  $('form#sendMessage').submit ->
    newMessage = $('#newMessage').val()
    unless newMessage is ''
      SS.server.app.sendMessage newMessage, (response) ->
        if response.error
          alert(response.error) 
        else
          $('#newMessage').val('')
    false
  

      
  # When a new message comes in, add it to the model and scroll the list (unless you've scrolled back to read previous messages)
  SS.events.on 'newMessage', (params) ->
    lounge.new_message_count++
    addMessage(params)
    SS.client.scroll.down('#messages', 450)
    
  # When a user signs in, add them to the list of Users Online
  SS.events.on 'signedIn', (params) ->
    unless lounge.user.cdid is params.cdid
      if Person.find(params.cdid)? then Person.find(params.cdid).signIn() else new Person(params).save()
  
  # Currently wrapping some error handling over this as we seem to be incurring multiple calls to signedOut :/
  SS.events.on 'signedOut', (params) ->
    try 
      Person.find(params).signOut()
    catch e
      console.error e
      

