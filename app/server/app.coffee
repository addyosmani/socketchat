exports.actions =

  # Called by the client to determin if the session is new or the user has already signed in
  init: (cb) ->
  
    @session.on 'disconnect', (session) ->
      SS.publish.broadcast 'signedOut', session.user_id
      session.user.logout ->
  
    if @session.user_id
      R.get "user:#{@session.user_id}", (err, data) =>
        if data
          @broadcastSignIn JSON.parse(data), cb
        else
          cb false
    else
      cb false

  # No message logging performed at the mo
  sendMessage: (message, cb) ->
    max_chars = 2000
    if message and message.length < max_chars
        data = {cdid: @session.user_id, body: message, date: Number(new Date())}
        SS.publish.broadcast 'newMessage', data
        R.lpush 'messages', JSON.stringify(data)
        cb true
    else
      cb {error: "Ooops! That message is way too big (over #{max_chars} chars!"}
  
  # Check to see if we have user's details stored in redis before doing an expensive lookup
  signIn: (cdid, cb) ->
    R.get "user:#{cdid}", (err, cached_user_data) =>
            R.set "user:#{cdid}", "user:#{cdid}", (err, data) =>
              @broadcastSignIn "user:#{cdid}", cb

  # Notify all users when a new person signs in
  broadcastSignIn: (data, cb) ->
    @session.setUserId data
    SS.publish.broadcast 'signedIn', data
    cb data


    
  loadPeople: (cdids, cb) ->
    keys = cdids.map (cdid) -> "user:#{cdid}"
    R.mget keys, (err, data) ->  cb(data)

 
looksSuspicious = (text) ->
  /</g.test(text) and /javascript:/g.test(text)

     
