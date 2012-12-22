// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var LineMarker, Marker, Raphael, Spine, indexOf, style;
    Spine = require('Spine');
    Raphael = require('Raphael');
    Marker = require('controllers/Marker');
    indexOf = require('util').indexOf;
    style = require('style');
    LineMarker = (function(_super) {

      __extends(LineMarker, _super);

      LineMarker.prototype.circles = null;

      LineMarker.prototype.lines = null;

      function LineMarker() {
        this.destroy = __bind(this.destroy, this);

        this.circleDrag = __bind(this.circleDrag, this);

        this.deselect = __bind(this.deselect, this);

        this.select = __bind(this.select, this);

        this.getBoundingPathString = __bind(this.getBoundingPathString, this);

        this.getIntersection = __bind(this.getIntersection, this);

        this.render = __bind(this.render, this);

        this.setupCircleHover = __bind(this.setupCircleHover, this);

        var p, points;
        LineMarker.__super__.constructor.apply(this, arguments);
        points = this.annotation.value.points;
        this.circles = this.picker.paper.set((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = points.length; _i < _len; _i++) {
            p = points[_i];
            _results.push(this.picker.paper.circle());
          }
          return _results;
        }).call(this));
        this.circles.toBack();
        this.circles.attr(style.circle);
        this.setupCircleHover();
        this.circles.drag(this.circleDrag, this.dragStart);
        this.lines = this.picker.paper.set((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = points.length; _i < _len; _i++) {
            p = points[_i];
            _results.push(this.picker.paper.path());
          }
          return _results;
        }).call(this));
        this.lines.toBack();
        this.lines.attr(style.boundingBox);
        this.annotation.trigger('change');
      }

      LineMarker.prototype.setupCircleHover = function() {
        var marker, out, over;
        marker = this;
        over = function() {
          marker.overCircle = this;
          return this.attr(style.circle.hover);
        };
        out = function() {
          return this.attr(style.circle);
        };
        return this.circles.hover(over, out);
      };

      LineMarker.prototype.render = function() {
        var circle, h, i, intersection, line, points, w, _i, _j, _len, _len1, _ref, _ref1, _ref2, _results;
        LineMarker.__super__.render.apply(this, arguments);
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        intersection = this.getIntersection();
        this.centerCircle.attr({
          cx: intersection.x * w,
          cy: intersection.y * h
        });
        this.centerCircle.attr({
          stroke: style[this.annotation.value.species]
        });
        this.label.attr({
          x: intersection.x * w,
          y: intersection.y * h
        });
        points = this.annotation.value.points;
        _ref1 = this.circles;
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          circle = _ref1[i];
          circle.attr({
            cx: points[i].x * w,
            cy: points[i].y * h
          });
        }
        _ref2 = this.lines;
        _results = [];
        for (i = _j = 0, _len1 = _ref2.length; _j < _len1; i = ++_j) {
          line = _ref2[i];
          _results.push(line.attr({
            path: this.lineBetween(this.circles[i], this.centerCircle)
          }));
        }
        return _results;
      };

      LineMarker.prototype.getIntersection = function() {
        var points, x, y;
        points = this.annotation.value.points;
        x = (points[0].x + points[1].x) / 2;
        y = (points[0].y + points[1].y) / 2;
        return {
          x: x,
          y: y
        };
      };

      LineMarker.prototype.getBoundingPathString = function() {
        var h, path, point, points, w, _i, _j, _len, _len1, _ref, _ref1, _step, _step1;
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        points = this.annotation.value.points;
        path = [];
        path.push('M', points[0].x * w, points[0].y * h);
        for (_i = 0, _len = points.length, _step = 2; _i < _len; _i += _step) {
          point = points[_i];
          path.push('L', point.x * w, point.y * h);
        }
        _ref1 = points.slice(1);
        for (_j = 0, _len1 = _ref1.length, _step1 = 2; _j < _len1; _j += _step1) {
          point = _ref1[_j];
          path.push('L', point.x * w, point.y * h);
        }
        path.push('z');
        return path.join(' ');
      };

      LineMarker.prototype.select = function() {
        var circle, h, i, points, w, _i, _len, _ref, _ref1;
        LineMarker.__super__.select.apply(this, arguments);
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        points = this.annotation.value.points;
        _ref1 = this.circles;
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          circle = _ref1[i];
          circle.animate({
            cx: points[i].x * w,
            cy: points[i].y * h,
            opacity: 1
          }, 200);
        }
        return this.lines.animate({
          opacity: 1
        }, 333);
      };

      LineMarker.prototype.deselect = function() {
        LineMarker.__super__.deselect.apply(this, arguments);
        this.circles.animate({
          opacity: 0.5
        }, 250);
        return this.lines.animate({
          opacity: 0.5
        }, 125);
      };

      LineMarker.prototype.circleDrag = function(dx, dy) {
        var h, i, points, w, _ref;
        this.moved = true;
        points = this.annotation.value.points;
        _ref = this.picker.getSize(), w = _ref.width, h = _ref.height;
        i = indexOf(this.circles, this.overCircle);
        points[i].x = this.limit(((this.startPoints[i].x * w) + dx) / w, 0.02);
        points[i].y = this.limit(((this.startPoints[i].y * h) + dy) / h, 0.04);
        return this.annotation.trigger('change');
      };

      LineMarker.prototype.destroy = function() {
        LineMarker.__super__.destroy.apply(this, arguments);
        this.circles.remove();
        return this.lines.remove();
      };

      return LineMarker;

    })(Marker);
    return module.exports = LineMarker;
  });

}).call(this);
