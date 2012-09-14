// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, Analytics, App, AppController, Authentication, GoogleAnalytics, Spine, User, config;
    Spine = require('Spine');
    $ = require('jQuery');
    config = require('zooniverse/config');
    User = require('zooniverse/models/User');
    Authentication = require('zooniverse/controllers/Authentication');
    AppController = require('zooniverse/controllers/App');
    GoogleAnalytics = require('zooniverse/controllers/GoogleAnalytics');
    Analytics = require('zooniverse/controllers/Analytics');
    App = (function(_super) {

      __extends(App, _super);

      App.configure('App', 'languages', 'el', 'controller', 'projects');

      function App() {
        var project, _i, _len, _ref, _ref1, _ref2;
        App.__super__.constructor.apply(this, arguments);
        if ((_ref = this.languages) == null) {
          this.languages = ['en'];
        }
        if ((_ref1 = this.projects) == null) {
          this.projects = [];
        }
        if (this.projects != null) {
          _ref2 = this.projects;
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            project = _ref2[_i];
            project.app = this;
          }
        }
        this.controller = new AppController({
          app: this,
          el: this.el,
          languages: this.languages
        });
        this.googleAnalytics = new GoogleAnalytics({
          account: config.googleAnalytics,
          domain: config.domain
        });
        this.analytics = new Analytics;
      }

      return App;

    })(Spine.Model);
    return module.exports = App;
  });

}).call(this);