# Description:
#   �݂��肳�񂪈��A�����Ă����@�\�ł��B
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ���͂悤 - "���͂悤�������܂��I"�ƕԓ�
#
# Notes:
#   ���߂č��܂����B
#
# Author:
#   susuwatarin


module.exports = (robot) ->

  robot.respond /���͂悤/i, (msg) ->
    msg.send "���͂悤�������܂��I"