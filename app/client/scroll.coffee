disable = {}
postion = {}

exports.down = (id, value) ->
  unless disable[id]?
    $(id).animate {scrollTop: $(id)[0].scrollHeight}, {duration: "slow", easing:"swing", queue: false}
    postion[id] = $(id)[0].scrollHeight - value

# Scolling is possible on both windows using the mouse wheel, though we need to make this more apparent
exports.enable = (divId, adjustmentLevel) ->
