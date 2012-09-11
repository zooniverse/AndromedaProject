// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var Analytics, App, GoogleAnalytics, Pager, Spine, TopBar, User, config, translateDocument;
    Spine = require('Spine');
    config = require('zooniverse/config');
    User = require('zooniverse/models/User');
    TopBar = require('zooniverse/controllers/TopBar');
    Pager = require('zooniverse/controllers/Pager');
    GoogleAnalytics = require('zooniverse/controllers/GoogleAnalytics');
    Analytics = require('zooniverse/controllers/Analytics');
    translateDocument = require('zooniverse/i18n').translateDocument;
    App = (function(_super) {

      __extends(App, _super);

      App.prototype.languages = null;

      App.prototype.projects = null;

      App.prototype.analytics = null;

      App.prototype.googleAnalytics = null;

      function App() {
        this.initAnalytics = __bind(this.initAnalytics, this);

        this.initPagers = __bind(this.initPagers, this);

        this.initTopBar = __bind(this.initTopBar, this);

        var project, _i, _len, _ref, _ref1;
        App.__super__.constructor.apply(this, arguments);
        if ((_ref = this.projects) == null) {
          this.projects = [];
        }
        if (!(this.projects instanceof Array)) {
          this.projects = [this.projects];
        }
        _ref1 = this.projects;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          project = _ref1[_i];
          project.app = this;
        }
        this.initTopBar();
        this.initPagers();
        this.initAnalytics();
        User.checkCurrent(this.projects[0]);
        translateDocument(this.languages[0]);
      }

      App.prototype.initTopBar = function() {
        this.topBar = new TopBar({
          languages: this.languages
        });
        return this.topBar.el.prependTo('body');
      };

      App.prototype.initPagers = function() {
        var pageContainer, _i, _len, _ref, _results;
        _ref = this.el.find('[data-page]').parent();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pageContainer = _ref[_i];
          _results.push(new Pager({
            el: pageContainer
          }));
        }
        return _results;
      };

      App.prototype.initAnalytics = function() {
        this.analytics = new Analytics;
        if (config.googleAnalytics) {
          return this.googleAnalytics = new GoogleAnalytics({
            account: config.googleAnalytics,
            domain: config.domain
          });
        }
      };

      return App;

    })(Spine.Controller);
    return module.exports = App;
  });

}).call(this);