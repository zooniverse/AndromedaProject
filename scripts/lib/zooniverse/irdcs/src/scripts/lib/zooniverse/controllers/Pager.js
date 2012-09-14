// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, ACTIVE_CLASS, AFTER_CLASS, BEFORE_CLASS, FOCUSABLE, PAGE_ATTR, Page, Pager, Route, Spine, delay;
    Spine = require('Spine');
    $ = require('jQuery');
    Route = require('zooniverse/controllers/Route');
    delay = require('zooniverse/util').delay;
    PAGE_ATTR = 'data-page';
    BEFORE_CLASS = 'before';
    ACTIVE_CLASS = 'active';
    AFTER_CLASS = 'after';
    FOCUSABLE = 'a, button, input, select, textarea';
    Page = (function(_super) {

      __extends(Page, _super);

      Page.prototype.pager = null;

      Page.prototype.name = '';

      Page.prototype.links = null;

      function Page() {
        this.deactivate = __bind(this.deactivate, this);

        this.activate = __bind(this.activate, this);

        var hash;
        Page.__super__.constructor.apply(this, arguments);
        this.name = this.el.attr(PAGE_ATTR);
        hash = '#!' + this.pager.path.replace(':page', this.name);
        this.links = $("a[href='" + hash + "'], [data-hash-association='" + hash + "']");
      }

      Page.prototype.activate = function() {
        var elAndLinks, element, oldTabIndex, _i, _len, _ref;
        _ref = this.el.find(FOCUSABLE);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          element = $(element);
          oldTabIndex = element.data('old-tabindex');
          if (oldTabIndex) {
            element.attr('tabindex', oldTabIndex);
          } else {
            element.removeAttr('tabindex');
          }
          element.data('old-tabindex', null);
        }
        elAndLinks = this.el.add(this.links);
        elAndLinks.removeClass(BEFORE_CLASS);
        elAndLinks.removeClass(AFTER_CLASS);
        elAndLinks.addClass(ACTIVE_CLASS);
        return this.el.trigger('pager-activate');
      };

      Page.prototype.deactivate = function(inactiveClass) {
        var elAndLinks, element, tabindex, _i, _len, _ref;
        _ref = this.el.find(FOCUSABLE);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          element = $(element);
          tabindex = element.attr('tabindex');
          element.data('old-tabindex', tabindex || null);
          element.attr('tabindex', -1);
        }
        elAndLinks = this.el.add(this.links);
        elAndLinks.removeClass(BEFORE_CLASS);
        elAndLinks.removeClass(AFTER_CLASS);
        elAndLinks.removeClass(ACTIVE_CLASS);
        elAndLinks.addClass(inactiveClass);
        return this.el.trigger('pager-deactivate');
      };

      return Page;

    })(Spine.Controller);
    Pager = (function(_super) {

      __extends(Pager, _super);

      Pager.prototype.pages = null;

      Pager.prototype.path = '';

      function Pager() {
        this.pathMatched = __bind(this.pathMatched, this);

        var page, _i, _len, _ref,
          _this = this;
        Pager.__super__.constructor.apply(this, arguments);
        this.path = (function() {
          var elPage, parent, segments, _i, _len, _ref;
          segments = [];
          elPage = _this.el.attr(PAGE_ATTR);
          if (elPage) {
            segments.push(elPage);
          }
          _ref = _this.el.parents("[" + PAGE_ATTR + "]");
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            parent = _ref[_i];
            segments.unshift($(parent).attr(PAGE_ATTR));
          }
          segments.push(':page');
          return '/' + segments.join('/');
        })();
        this.pages = (function() {
          var child, _i, _len, _ref, _results;
          _ref = _this.el.children("[" + PAGE_ATTR + "]");
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _results.push(new Page({
              el: child,
              pager: _this
            }));
          }
          return _results;
        })();
        _ref = this.pages;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          page = _ref[_i];
          if (page.el.hasClass('active')) {
            page.activate();
          }
        }
        this.route = new Route(this.path, this.pathMatched);
      }

      Pager.prototype.pathMatched = function(pageName) {
        var disabledClass, page, _i, _len, _ref, _results;
        disabledClass = BEFORE_CLASS;
        _ref = this.pages;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          page = _ref[_i];
          if (page.name === pageName) {
            page.activate();
            _results.push(disabledClass = AFTER_CLASS);
          } else {
            _results.push(page.deactivate(disabledClass));
          }
        }
        return _results;
      };

      return Pager;

    })(Spine.Controller);
    return module.exports = Pager;
  });

}).call(this);
