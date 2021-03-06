// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  define(function(require, exports, module) {
    var $, Button, Dialog, Spine, TEMPLATE, delay;
    Spine = require('Spine');
    $ = require('jQuery');
    delay = require('zooniverse/util').delay;
    TEMPLATE = require('zooniverse/views/Dialog');
    Button = (function(_super) {

      __extends(Button, _super);

      Button.prototype.label = 'OK';

      Button.prototype.value = null;

      Button.prototype.deferred = null;

      Button.prototype.tag = 'button';

      Button.prototype.className = 'dialog-button';

      Button.prototype.events = {
        click: 'onClick'
      };

      function Button() {
        this.onClick = __bind(this.onClick, this);
        Button.__super__.constructor.apply(this, arguments);
        this.el.html(this.label);
        this.el.val(this.value);
      }

      Button.prototype.onClick = function() {
        return this.deferred.resolve(this.value);
      };

      return Button;

    })(Spine.Controller);
    Dialog = (function(_super) {

      __extends(Dialog, _super);

      Dialog.prototype.content = 'Alert!';

      Dialog.prototype.buttons = null;

      Dialog.prototype.target = 'body';

      Dialog.prototype.promise = null;

      Dialog.prototype.className = 'dialog';

      Dialog.prototype.template = TEMPLATE;

      Dialog.prototype.blockers = null;

      Dialog.prototype.elements = {
        '.content': 'contentContainer',
        '.buttons': 'buttonsContainer'
      };

      function Dialog() {
        this.close = __bind(this.close, this);

        this.render = __bind(this.render, this);

        var button, deferred, i, label, value, _i, _len, _ref, _ref1,
          _this = this;
        Dialog.__super__.constructor.apply(this, arguments);
        if ((_ref = this.buttons) == null) {
          this.buttons = [
            {
              'OK': true
            }
          ];
        }
        if (!(this.target instanceof $)) {
          this.target = $(this.target).first();
        }
        deferred = new $.Deferred;
        this.promise = deferred.promise();
        this.promise.done(function() {
          var args;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          if (typeof _this.done === "function") {
            _this.done.apply(_this, args);
          }
          return _this.close();
        });
        _ref1 = this.buttons;
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          button = _ref1[i];
          for (label in button) {
            value = button[label];
            this.buttons[i] = new Button({
              label: label,
              value: value,
              deferred: deferred
            });
          }
        }
        this.render();
        this.el.add(this.blocker).appendTo('body');
        this.reposition();
        this.el.add(this.blocker).addClass('open');
      }

      Dialog.prototype.render = function() {
        var button, _i, _len, _ref;
        this.html(this.template);
        this.contentContainer.html(this.content);
        _ref = this.buttons;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          button = _ref[_i];
          button.el.appendTo(this.buttonsContainer);
        }
        this.el.addClass(this.constructor.prototype.className);
        return this.blocker = $('<div class="dialog-blocker"></div>');
      };

      Dialog.prototype.reposition = function() {
        var size, targetOffset, targetSize;
        size = {
          width: this.el.outerWidth(),
          height: this.el.outerHeight()
        };
        targetSize = {
          width: this.target.outerWidth(),
          height: this.target.outerHeight()
        };
        targetOffset = this.target.offset();
        this.el.offset({
          left: targetOffset.left + (targetSize.width / 2) - (size.width / 2),
          top: targetOffset.top + (targetSize.height / 2) - (size.height / 2)
        });
        this.blocker.width(targetSize.width);
        this.blocker.height(targetSize.height);
        return this.blocker.offset(targetOffset);
      };

      Dialog.prototype.close = function() {
        var _this = this;
        this.el.add(this.blocker).removeClass('open');
        return delay(500, function() {
          var button, _i, _len, _ref;
          _this.blocker.remove();
          _ref = _this.buttons;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            button = _ref[_i];
            button.release();
          }
          return _this.release();
        });
      };

      return Dialog;

    })(Spine.Controller);
    return module.exports = Dialog;
  });

}).call(this);
