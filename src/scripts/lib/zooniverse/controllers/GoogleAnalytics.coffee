define (require, exports, module) ->
  $ = require 'jQuery'

  class GoogleAnalytics
    @instance: null

    account: ''
    domain: ''

    queue: null

    constructor: ({@account, @domain}) ->
      throw new Error 'Google Analytics already instantiated' if @constructor.instance
      throw new Error 'No account for Google Analytics' unless @account
      throw new Error 'No domain for Google Analytics' unless @domain

      @queue = window._gaq ?= [
        ['_setAccount', @account]
        ['_setDomainName', @domain]
        ['_trackPageview']
      ]

      src = 'http://www.google-analytics.com/ga.js'
      src = src.replace 'http://www', 'https://ssl' if location.protocol is 'https:'
      $("<script src='#{src}'></script>").appendTo 'head'

      @track location.href
      $(window).on 'hashchange', =>
        @track location.href

      @constructor.instance = @

    track: (location) =>
      @queue.push ['_trackPageview', location]

  module.exports = GoogleAnalytics
