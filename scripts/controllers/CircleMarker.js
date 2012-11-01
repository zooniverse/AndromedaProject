// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var CircleMarker, Marker, Raphael, Spine, style;
    Spine = require('Spine');
    Raphael = require('Raphael');
    Marker = require('controllers/Marker');
    style = require('style');
    CircleMarker = (function(_super) {

      __extends(CircleMarker, _super);

      CircleMarker.prototype.radiusHandle = null;

      CircleMarker.prototype.radiusLine = null;

      CircleMarker.prototype.boundingCircle = null;

      function CircleMarker() {
        this.destroy = __bind(this.destroy, this);

        this.deselect = __bind(this.deselect, this);

        this.select = __bind(this.select, this);

        this.radiusHandleDrag = __bind(this.radiusHandleDrag, this);

        this.render = __bind(this.render, this);
        CircleMarker.__super__.constructor.apply(this, arguments);
        this.radiusHandle = this.picker.paper.circle();
        this.radiusHandle.toBack();
        this.radiusHandle.attr(style.circle);
        this.radiusHandle.click(this.stopPropagation);
        this.radiusHandle.drag(this.radiusHandleDrag, this.dragStart);
        this.radiusLine = this.picker.paper.path();
        this.radiusLine.toBack();
        this.radiusLine.attr(style.boundingBox);
        this.boundingCircle = this.picker.paper.circle();
        this.boundingCircle.toBack();
        this.boundingCircle.attr(style.line);
        this.annotation.trigger('change');
      }

      CircleMarker.prototype.render = function() {
        var centerPoint, h, radiusPoint, w, _ref;
        CircleMarker.__super__.render.apply(this, arguments);
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        centerPoint = this.annotation.value.points[0];
        this.centerCircle.attr({
          stroke: style[this.annotation.value.species],
          cx: centerPoint.x * w,
          cy: centerPoint.y * h
        });
        this.label.attr({
          x: Math.round(centerPoint.x * w),
          y: Math.round(centerPoint.y * h)
        });
        radiusPoint = this.annotation.value.points[this.annotation.value.points.length - 1];
        this.radiusHandle.attr({
          cx: radiusPoint.x * w,
          cy: radiusPoint.y * h
        });
        this.radiusLine.attr({
          path: this.lineBetween(this.centerCircle, this.radiusHandle)
        });
        return this.boundingCircle.attr({
          cx: centerPoint.x * w,
          cy: centerPoint.y * h,
          r: this.getRadius(centerPoint, radiusPoint)
        });
      };

      CircleMarker.prototype.radiusHandleDrag = function(dx, dy) {
        var h, radiusPoint, w, _ref;
        this.moved = true;
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        radiusPoint = this.annotation.value.points[this.annotation.value.points.length - 1];
        radiusPoint.x = this.limit(((this.startPoints[1].x * w) + dx) / w, 0.02);
        radiusPoint.y = this.limit(((this.startPoints[1].y * h) + dy) / h, 0.04);
        return this.annotation.trigger('change');
      };

      CircleMarker.prototype.getRadius = function(centerPoint, radiusPoint) {
        var aSquared, bSquared, h, w, _ref;
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        aSquared = Math.pow((centerPoint.x * w) - (radiusPoint.x * w), 2);
        bSquared = Math.pow((centerPoint.y * h) - (radiusPoint.y * h), 2);
        return Math.sqrt(aSquared + bSquared);
      };

      CircleMarker.prototype.select = function() {
        var centerPoint, h, radiusPoint, w, _ref;
        CircleMarker.__super__.select.apply(this, arguments);
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        centerPoint = this.annotation.value.points[0];
        radiusPoint = this.annotation.value.points[this.annotation.value.points.length - 1];
        this.radiusHandle.animate({
          cx: radiusPoint.x * w,
          cy: radiusPoint.y * h
        }, 250);
        this.radiusLine.animate({
          opacity: 1
        }, 250);
        return this.boundingCircle.animate({
          r: this.getRadius(centerPoint, radiusPoint),
          opacity: 1
        }, 250);
      };

      CircleMarker.prototype.deselect = function() {
        var centerPoint, h, w, _ref;
        CircleMarker.__super__.deselect.apply(this, arguments);
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        centerPoint = this.annotation.value.points[0];
        this.radiusHandle.animate({
          cx: centerPoint.x * w,
          cy: centerPoint.y * h
        }, 250);
        return this.radiusLine.animate({
          opacity: 0
        }, 125, this.boundingCircle.animate({
          opacity: 0.5
        }, 250));
      };

      CircleMarker.prototype.destroy = function() {
        CircleMarker.__super__.destroy.apply(this, arguments);
        this.radiusHandle.remove();
        this.radiusLine.remove();
        return this.boundingCircle.remove();
      };

      return CircleMarker;

    })(Marker);
    return module.exports = CircleMarker;
  });

}).call(this);
