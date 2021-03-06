﻿# Description:
#   電車遅延情報をSlackに投稿する
#
# Commands:
#   hubot train < all > - Return train info
#
# Author:
#   Tmano

cheerio = require 'cheerio-httpcli'

module.exports = (robot) ->

  searchAllTrain = (msg) ->
    # send HTTP request
    baseUrl = 'http://transit.yahoo.co.jp/traininfo/gc/13/'
    cheerio.fetch baseUrl, (err, $, res) ->
      if $('.elmTblLstLine.trouble').find('a').length == 0
        msg.send "事故や遅延情報はありません"
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
    # 京浜東北線
    jr_kt = 'http://transit.yahoo.co.jp/traininfo/detail/22/0/'
    # 京急本線
    kq = 'https://transit.yahoo.co.jp/traininfo/detail/120/0/'
    if target == "kq"
      searchTrain(kq, msg)
    else if target == "jr_kt"
      searchTrain(jr_kt, msg)
    else if target == "all"
      searchAllTrain(msg)
    else
      msg.send "#{target}は検索できなし( ?ω? ) usage: @world_conquistador [kq | jr_kt | all]"

  searchTrain = (url, msg) ->
    cheerio.fetch url, (err, $, res) ->
      title = "#{$('h1').text()}"
      if $('.icnNormalLarge').length
        robot.send {room: "#random"}, "#{title}は遅延してないので安心しろ。"
      else
        info = $('.trouble p').text()
        robot.send {room: "#train_info"}, ":warning: #{title}は遅延しとる。フザケンナ。\n#{info}"