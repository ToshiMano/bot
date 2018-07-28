cheerio = require 'cheerio-httpcli'
cronJob = require('cron').CronJob

module.exports = (robot) ->

  searchAllTrain = (msg) ->
    # send HTTP request
    baseUrl = 'https://transit.yahoo.co.jp/traininfo/gc/13/'
    cheerio.fetch baseUrl, (err, $, res) ->
      if $('.elmTblLstLine.trouble').find('a').length == 0
        msg.send "���̂�x�����͂���܂���"
        return
      $('.elmTblLstLine.trouble a').each ->
        url = $(this).attr('href')
        cheerio.fetch url, (err, $, res) ->
          title = ":warning: #{$('h1').text()} #{$('.subText').text()}"
          result = ""
          $('.trouble').each ->
            trouble = $(this).text().trim()
            result += "- " + trouble + "\r\n"
          msg.send "#{title}\r\n#{result}"

  robot.respond /train (.+)/i, (msg) ->
    target = msg.match[1]
    # ���l���k��
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    # ���}�{��
    kq = 'https://transit.yahoo.co.jp/traininfo/detail/120/0/'
    if target == "kq"
      searchTrain(kq, msg)
    else if target == "jr_kt"
      searchTrain(jr_kt, msg)
    else if target == "all"
      searchAllTrain(msg)
    else
      msg.send "#{target}�͌����ł��Ȃ�( ?��? ) usage: @world_conquistador [kq | jr_kt | all]"

  searchTrain = (url, msg) ->
    cheerio.fetch url, (err, $, res) ->
      title = "#{$('h1').text()}"
      if $('.icnNormalLarge').length
        msg.send ":ok_woman: #{title}�͒x�����ĂȂ��̂ň��S����B"
      else
        info = $('.trouble p').text()
        msg.send ":warning: #{title}�͒x�����Ƃ�B�t�U�P���i�B\n#{info}"

  # cronJob�̈����́A�b�E���E���ԁE���E���E�j���̏���
  new cronJob('0 20,30,40,50 8 * * 1-5', () ->
    # ���}�{��(Yahoo!�^�s��񂩂�I������URL��ݒ肷��B)
    kq = 'https://transit.yahoo.co.jp/traininfo/detail/120/0/'
    # ���l���k��
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    searchTrainCron(kq)
    searchTrainCron(jr_kt)
  ).start()

  new cronJob('0 30,59 18 * * 1-5', () ->
    # ���}�{��(Yahoo!�^�s��񂩂�I������URL��ݒ肷��B)
    kq = 'https://transit.yahoo.co.jp/traininfo/detail/120/0/'
    # ���l���k��
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    searchTrainCron(kq)
    searchTrainCron(jr_kt)
  ).start()

  searchTrainCron = (url) ->
    cheerio.fetch url, (err, $, res) ->
      #�H����(Yahoo!�^�s��񂩂琳�����̂��擾)
      title = "#{$('h1').text()}"
      if $('.icnNormalLarge').length
        # �ʏ�^�]�̏ꍇ
        #robot.send {room: "#random"}, "#{title}�͒x�����ĂȂ��̂ň��S����B"
      else
        # �ʏ�^�]�ȊO�̏ꍇ
        info = $('.trouble p').text()
        robot.send {room: "#train_info"}, ":warning: #{title}�͒x�����Ƃ�B�t�U�P���i�B\n#{info}"