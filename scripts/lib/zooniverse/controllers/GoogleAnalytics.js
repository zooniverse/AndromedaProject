// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function(require, exports, module) {
    var $, GoogleAnalytics;
    $ = require('jQuery');
    GoogleAnalytics = (function() {

      GoogleAnalytics.instance = null;

      GoogleAnalytics.prototype.account = '';

      GoogleAnalytics.prototype.domain = '';

      GoogleAnalytics.prototype.queue = null;

      function GoogleAnalytics(_arg) {
        var src, _ref,
          _this = this;
        this.account = _arg.account, this.domain = _arg.domain;
        this.track = __bind(this.track, this);

        if (this.constructor.instance) {
          throw new Error('Google Analytics already instantiated');
        }
        if (!this.account) {
          throw new Error('No account for Google Analytics');
        }
        if (!this.domain) {
          throw new Error('No domain for Google Analytics');
        }
        this.queue = (_ref = window._gaq) != null ? _ref : window._gaq = [['_setAccount', this.account], ['_setDomainName', this.domain], ['_trackPageview']];
        src = 'http://www.google-analytics.com/ga.js';
        if (location.protocol === 'https:') {
          src = src.replace('http://www', 'https://ssl');
        }
        $("<script src='" + src + "'></script>").appendTo('head');
        this.track(location.href);
        $(window).on('hashchange', function() {
          return _this.track(location.href);
        });
        this.constructor.instance = this;
      }

      GoogleAnalytics.prototype.track = function(location) {
        return this.queue.push(['_trackPageview', location]);
      };

      return GoogleAnalytics;

    })();
    return module.exports = GoogleAnalytics;
  });

}).call(this);