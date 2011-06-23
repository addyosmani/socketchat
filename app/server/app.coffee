# Server-side code

exports.actions =

  init: (cb) ->  
    if @session.user_id
      R.get "user:#{@session.user_id}", (err, data) =>
        if data then cb data else cb false
    else
      cb false

  sendMessage: (message, cb) ->
    # TODO: Check messages for malformed content, HTML tags, etc
    SS.publish.broadcast 'newMessage', {user: @session.user_id, body: message}
    cb true
  
  signIn: (user, cb) ->
    @session.setUserId(user)
    cb user
