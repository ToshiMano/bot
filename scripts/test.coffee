# Description:
#   みくりさんが挨拶をしてくれる機能です。
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot おはよう - "おはようございます！"と返答
#
# Notes:
#   初めて作りました。
#
# Author:
#   susuwatarin


module.exports = (robot) ->

  robot.respond /おはよう/i, (msg) ->
    msg.send "おはようございます！"