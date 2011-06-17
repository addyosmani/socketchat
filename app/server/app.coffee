exports.actions =

  init: (cb) ->  
    if @session.user_id
      R.get "user:#{@session.user_id}", (err, data) => if data then cb data else cb false
    else
      cb false

  sendMessage: (message, cb) ->
    if message
        SS.publish.broadcast 'newMessage', {cdid: @session.user_id, body: message}
        cb true
    else
      cb false
  
  signIn: (cdid, cb) -> R.get "user:#{cdid}", (err, cached_user_data) => R.set "user:#{cdid}", "user:#{cdid}", (err, data) => cb "user:#{cdid}"