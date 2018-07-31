# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob


module.exports = (robot) ->

  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg

  # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  # #your_channelと言う部屋に、平日の18:30時に実行
  new cronJob('0 15,20,30, * * * 1-5', () ->
    # ↑のほうで宣言しているsendメソッドを実行する
    send '#your_channel', "@here そろそろ帰る準備をしよう"
  ).start()

  # #your_channelと言う部屋に、平日の13:00時に実行
  new cronJob('0 0 * * * 1-5', () ->
    send '#your_channel', "@here ランチの時間だよ！！"
  ).start()