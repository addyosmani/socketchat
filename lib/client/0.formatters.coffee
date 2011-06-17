# Formatters

short_months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

Number::shortDate = ->
  date = new Date(@)
  "#{date.getDate()} #{short_months[date.getMonth()]} - #{date.getUTCHours().pad2()}:#{date.getUTCMinutes().pad2()}:#{date.getUTCSeconds().pad2()} UTC"

String::htmlEncode = ->
  @replace(/>/g, '&gt;').replace(/</g, '&lt;')

Number::pad2 = ->
  (if @ < 10 then '0' else '') + @
