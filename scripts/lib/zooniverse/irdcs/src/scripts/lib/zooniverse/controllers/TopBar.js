// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(function(require, exports, module) {
    var $, LoginForm, Spine, TopBar, User, delay, remove, template, _ref;
    Spine = require('Spine');
    $ = require('jQuery');
    _ref = require('zooniverse/util'), delay = _ref.delay, remove = _ref.remove;
    User = require('zooniverse/models/User');
    LoginForm = require('zooniverse/controllers/LoginForm');
    template = require('zooniverse/views/TopBar');
    TopBar = (function(_super) {

      __extends(TopBar, _super);

      TopBar.instance = null;

      TopBar.prototype.languages = null;

      TopBar.prototype.langMap = {
        en: 'English',
        po: 'Polski',
        de: 'Deutsche'
      };

      TopBar.prototype.dropdownsToHide = null;

      TopBar.prototype.className = 'zooniverse-top-bar';

      TopBar.prototype.template = template;

      TopBar.prototype.app = null;

      TopBar.prototype.events = {
        'mouseenter .z-dropdown': 'onDropdownEnter',
        'mouseleave .z-dropdown': 'onDropdownLeave',
        'click .z-accordion > :first-child': 'onAccordionClick',
        'click .z-languages a': 'changeLanguage'
      };

      TopBar.prototype.elements = {
        '.z-languages > :first-child': 'languageLabel',
        '.z-languages :last-child': 'languageList',
        '.z-login > :first-child': 'usernameContainer',
        '.z-login > :last-child': 'loginFormContainer'
      };

      function TopBar() {
        this.updateLogin = __bind(this.updateLogin, this);

        this.updateLanguages = __bind(this.updateLanguages, this);

        var accordionContainers, dropdownContainers;
        if (this.constructor.instance != null) {
          return this.constructor.instance;
        }
        this.constructor.instance = this;
        TopBar.__super__.constructor.apply(this, arguments);
        this.dropdownsToHide = [];
        this.html(this.template);
        dropdownContainers = this.el.find('.z-dropdown').children(':last-child');
        dropdownContainers.css({
          display: 'none',
          opacity: 0
        });
        accordionContainers = this.el.find('.z-accordion > :last-child');
        accordionContainers.css({
          height: 0,
          opacity: 0
        });
        this.updateLanguages();
        User.bind('sign-in', this.updateLogin);
        new LoginForm({
          el: this.loginFormContainer
        });
        this.updateLogin();
        this.el.find(':last-child').addClass('last-child');
      }

      TopBar.prototype.updateLanguages = function() {
        var lang, _i, _len, _ref1, _results;
        this.languageLabel.empty();
        this.languageList.empty();
        _ref1 = this.languages;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          lang = _ref1[_i];
          this.languageLabel.append("<span lang=\"" + lang + "\">" + (lang.toUpperCase()) + "</span>");
          _results.push(this.languageList.append("<li><a href=\"#" + lang + "\">" + (lang.toUpperCase()) + " <em>" + this.langMap[lang] + "</em></a></li>"));
        }
        return _results;
      };

      TopBar.prototype.updateLogin = function() {
        var _ref1;
        return this.usernameContainer.html(((_ref1 = User.current) != null ? _ref1.name : void 0) || 'Sign in');
      };

      TopBar.prototype.onDropdownEnter = function(e) {
        var container, target;
        target = $(e.currentTarget);
        container = target.children().last();
        remove(target, {
          from: this.dropdownsToHide
        });
        container.css({
          display: ''
        });
        return container.stop().animate({
          opacity: 1
        }, 1);
      };

      TopBar.prototype.onDropdownLeave = function(e) {
        var container, target,
          _this = this;
        target = $(e.currentTarget);
        container = target.children().last();
        this.dropdownsToHide.push(target);
        return delay(1, function() {
          if (__indexOf.call(_this.dropdownsToHide, target) < 0) {
            return;
          }
          return container.stop().animate({
            opacity: 0
          }, 1, function() {
            return delay(function() {
              return container.css({
                display: 'none'
              });
            });
          });
        });
      };

      TopBar.prototype.onAccordionClick = function(e) {
        var closed, container, naturalHeight, target;
        target = $(e.currentTarget).parent();
        container = target.children().last();
        closed = container.height() === 0;
        if (closed) {
          container.css({
            height: ''
          });
          naturalHeight = container.height();
          container.css({
            height: 0
          });
          return container.animate({
            height: naturalHeight,
            opacity: 1
          });
        } else {
          return container.animate({
            height: 0,
            opacity: 0
          });
        }
      };

      TopBar.prototype.changeLanguage = function(e) {
        var lang;
        e.preventDefault();
        lang = e.currentTarget.hash.slice(-2);
        return $('html').attr({
          lang: lang
        });
      };

      return TopBar;

    })(Spine.Controller);
    return module.exports = TopBar;
  });

}).call(this);
