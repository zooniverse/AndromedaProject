// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, Annotation, AxesMarker, CircleMarker, CreaturePicker, Marker, Raphael, Spine, TEMPLATE, style;
    Spine = require('Spine');
    $ = require('jQuery');
    Raphael = require('Raphael');
    Marker = require('controllers/Marker');
    CircleMarker = require('controllers/CircleMarker');
    AxesMarker = require('controllers/AxesMarker');
    Annotation = require('zooniverse/models/Annotation');
    TEMPLATE = require('views/CreaturePicker');
    style = require('style');
    CreaturePicker = (function(_super) {
      var ESC;

      __extends(CreaturePicker, _super);

      CreaturePicker.prototype.className = 'creature-picker';

      CreaturePicker.prototype.template = TEMPLATE;

      CreaturePicker.prototype.paper = null;

      CreaturePicker.prototype.strayCircles = null;

      CreaturePicker.prototype.strayAxes = null;

      CreaturePicker.prototype.markers = null;

      CreaturePicker.prototype.selectedSpecies = '';

      CreaturePicker.prototype.selectedMarkerType = '';

      CreaturePicker.prototype.disabled = false;

      CreaturePicker.prototype.elements = {
        '.selection-area': 'selectionArea',
        '.selection-area img': 'image'
      };

      CreaturePicker.prototype.events = {
        'mousedown': 'onMouseDown',
        'touchstart': 'onTouchStart',
        'touchmove': 'onTouchMove',
        'touchend': 'onTouchEnd'
      };

      function CreaturePicker() {
        this.resetStrays = __bind(this.resetStrays, this);

        this.changeClassification = __bind(this.changeClassification, this);

        this.setDisabled = __bind(this.setDisabled, this);

        this.onTouchEnd = __bind(this.onTouchEnd, this);

        this.onTouchMove = __bind(this.onTouchMove, this);

        this.onTouchStart = __bind(this.onTouchStart, this);

        this.createMarking = __bind(this.createMarking, this);

        this.createAxesMarker = __bind(this.createAxesMarker, this);

        this.createCircleMarker = __bind(this.createCircleMarker, this);

        this.checkStrays = __bind(this.checkStrays, this);

        this.onMouseUp = __bind(this.onMouseUp, this);

        this.onMouseMove = __bind(this.onMouseMove, this);

        this.onMouseDown = __bind(this.onMouseDown, this);

        this.createStrayBoundingCircle = __bind(this.createStrayBoundingCircle, this);

        this.createStrayAxis = __bind(this.createStrayAxis, this);

        this.createStrayCircle = __bind(this.createStrayCircle, this);

        this.resize = __bind(this.resize, this);

        this.getSize = __bind(this.getSize, this);

        this.reset = __bind(this.reset, this);

        this.delegateEvents = __bind(this.delegateEvents, this);
        CreaturePicker.__super__.constructor.apply(this, arguments);
        this.html(this.template);
        this.paper = Raphael(this.selectionArea[0], '100%', '100%');
        this.image.insertBefore(this.paper.canvas);
        this.changeClassification(null);
      }

      ESC = 27;

      CreaturePicker.prototype.delegateEvents = function() {
        var _this = this;
        CreaturePicker.__super__.delegateEvents.apply(this, arguments);
        $(document).on('mousemove', this.onMouseMove);
        $(document).on('mouseup', this.onMouseUp);
        return $(document).on('keydown', function(e) {
          if (e.keyCode === ESC) {
            _this.resetStrays();
            return _this.classifier.indicator.setStep(0);
          }
        });
      };

      CreaturePicker.prototype.reset = function() {
        var subject;
        this.image.attr('src', this.classifier.workflow.selection[0].location.standard);
        subject = this.classifier.workflow.selection[0];
        return console.log(subject);
      };

      CreaturePicker.prototype.getSize = function() {
        return {
          width: this.image.width(),
          height: this.image.height()
        };
      };

      CreaturePicker.prototype.resize = function() {
        var elProportion, imageProportion, marker, _i, _len, _ref, _results;
        imageProportion = this.image[0].naturalWidth / this.image[0].naturalHeight;
        elProportion = this.el.width() / this.el.height();
        if (imageProportion < elProportion) {
          this.selectionArea.css({
            width: '',
            height: '100%'
          });
          this.image.css({
            width: '',
            height: '100%'
          });
          this.selectionArea.css({
            width: this.image.width()
          });
          this.selectionArea.css({
            left: (this.el.width() - this.selectionArea.width()) / 2,
            top: ''
          });
        } else {
          this.selectionArea.css({
            width: '100%',
            height: ''
          });
          this.image.css({
            width: '100%',
            height: ''
          });
          this.selectionArea.css({
            height: this.image.height()
          });
          this.selectionArea.css({
            left: '',
            top: (this.el.height() - this.selectionArea.height()) / 2
          });
        }
        this.paper.setSize(this.selectionArea.width(), this.selectionArea.height());
        _ref = this.markers || [];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          marker = _ref[_i];
          _results.push(marker.render());
        }
        return _results;
      };

      CreaturePicker.prototype.createStrayCircle = function(cx, cy) {
        var circle;
        circle = this.paper.circle(cx, cy);
        circle.attr(style.circle);
        this.strayCircles.push(circle);
        this.el.trigger('create-stray-circle');
        return circle;
      };

      CreaturePicker.prototype.createStrayAxis = function() {
        var line, strayCircle1, strayCircle2;
        strayCircle1 = this.strayCircles[this.strayCircles.length - 2];
        strayCircle2 = this.strayCircles[this.strayCircles.length - 1];
        line = this.paper.path(Marker.prototype.lineBetween(strayCircle1, strayCircle2));
        line.toBack();
        line.attr(style.boundingBox);
        this.strayAxes.push(line);
        this.el.trigger('create-stray-axis');
        return line;
      };

      CreaturePicker.prototype.createStrayBoundingCircle = function() {
        var circle, cx, cy;
        cx = this.strayCircles[0].attr('cx');
        cy = this.strayCircles[0].attr('cy');
        circle = this.paper.circle(cx, cy);
        circle.attr(style.line);
        this.strayAxes.push(circle);
        return circle;
      };

      CreaturePicker.prototype.mouseIsDown = false;

      CreaturePicker.prototype.onMouseDown = function(e) {
        var left, m, top, _i, _len, _ref, _ref1;
        if (this.disabled) {
          return;
        }
        if (!this.image.add(this.paper.canvas).is(e.target)) {
          return;
        }
        _ref = this.markers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          m = _ref[_i];
          if (m.selected) {
            m.deselect();
          }
        }
        this.mouseIsDown = true;
        _ref1 = this.selectionArea.offset(), left = _ref1.left, top = _ref1.top;
        this.createStrayCircle(e.pageX - left, e.pageY - top);
        this.classifier.indicator.setStep(this.strayCircles.length);
        return typeof e.preventDefault === "function" ? e.preventDefault() : void 0;
      };

      CreaturePicker.prototype.dragThreshold = 3;

      CreaturePicker.prototype.mouseMoves = 0;

      CreaturePicker.prototype.movementCircle = null;

      CreaturePicker.prototype.movementAxis = null;

      CreaturePicker.prototype.movementBoundingCircle = null;

      CreaturePicker.prototype.onMouseMove = function(e) {
        var fauxPoint, height, left, secondLastCircle, top, width, _ref, _ref1;
        if (!(this.mouseIsDown && !this.disabled)) {
          return;
        }
        this.mouseMoves += 1;
        if (this.mouseMoves < this.dragThreshold) {
          return;
        }
        _ref = this.getSize(), width = _ref.width, height = _ref.height;
        _ref1 = this.selectionArea.offset(), left = _ref1.left, top = _ref1.top;
        this.movementCircle || (this.movementCircle = this.createStrayCircle());
        fauxPoint = {
          x: Marker.prototype.limit((e.pageX - left) / width, 0.01),
          y: Marker.prototype.limit((e.pageY - top) / height, 0.01)
        };
        this.movementCircle.attr({
          cx: fauxPoint.x * width,
          cy: fauxPoint.y * height
        });
        this.movementAxis || (this.movementAxis = this.createStrayAxis());
        secondLastCircle = this.strayCircles[this.strayCircles.length - 2];
        this.movementAxis.attr({
          path: Marker.prototype.lineBetween(secondLastCircle, this.movementCircle)
        });
        if (this.selectedMarkerType === 'circle') {
          this.movementBoundingCircle || (this.movementBoundingCircle = this.createStrayBoundingCircle());
          return this.movementBoundingCircle.attr({
            r: this.movementAxis.getTotalLength()
          });
        }
      };

      CreaturePicker.prototype.onMouseUp = function(e) {
        if (!(this.mouseIsDown && !this.disabled)) {
          return;
        }
        this.mouseIsDown = false;
        this.mouseMoves = 0;
        this.classifier.indicator.setStep(this.strayCircles.length);
        this.checkStrays();
        this.movementCircle = null;
        this.movementAxis = null;
        return this.movementBoundingCircle = null;
      };

      CreaturePicker.prototype.checkStrays = function() {
        var marker,
          _this = this;
        if (this.strayCircles.length === 1) {
          this.resetStrays();
        }
        if (this.strayCircles.length === 2) {
          if (this.selectedMarkerType === 'circle') {
            marker = this.createCircleMarker();
          } else {
            this.el.trigger('create-half-axes-marker');
          }
        } else if (this.strayCircles.length === 3) {
          this.strayCircles.pop().remove();
        } else if (this.strayCircles.length === 4) {
          marker = this.createAxesMarker();
        }
        if (marker != null) {
          this.markers.push(marker);
          setTimeout(marker.deselect, 250);
          marker.bind('select', function(marker) {
            var m, _i, _len, _ref;
            _ref = _this.markers;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              m = _ref[_i];
              if (m !== marker) {
                m.deselect();
              }
            }
            return _this.trigger('change-selection');
          });
          marker.bind('deselect', function() {
            return _this.trigger('change-selection');
          });
          marker.bind('release', function() {
            var i, m, _i, _len, _ref, _results;
            _ref = _this.markers;
            _results = [];
            for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
              m = _ref[i];
              if (m === marker) {
                _results.push(_this.markers.splice(i, 1));
              }
            }
            return _results;
          });
          return this.resetStrays();
        }
      };

      CreaturePicker.prototype.createCircleMarker = function(x, y) {
        var marker, marking;
        marking = this.createMarking();
        console.log(marking);
        marker = new CircleMarker({
          annotation: marking,
          picker: this
        });
        this.el.trigger('create-circle-marker');
        return marker;
      };

      CreaturePicker.prototype.createAxesMarker = function() {
        var marker, marking;
        marking = this.createMarking();
        marker = new AxesMarker({
          annotation: marking,
          picker: this
        });
        this.el.trigger('create-axes-marker');
        return marker;
      };

      CreaturePicker.prototype.createMarking = function() {
        var annotation, circle, height, point, points, width, _i, _len, _ref, _ref1;
        _ref = this.getSize(), width = _ref.width, height = _ref.height;
        points = [];
        _ref1 = this.strayCircles;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          circle = _ref1[_i];
          point = {
            x: circle.attr('cx') / width,
            y: circle.attr('cy') / height
          };
          points.push(point);
        }
        console.log(this.classifier);
        annotation = Annotation.create({
          classification: this.classifier.classification,
          value: {
            species: this.selectedSpecies,
            points: points
          }
        });
        this.el.trigger('create-marking');
        return annotation;
      };

      CreaturePicker.prototype.onTouchStart = function(e) {
        e.preventDefault();
        return this.onMouseDown(e.originalEvent.touches[0]);
      };

      CreaturePicker.prototype.onTouchMove = function(e) {
        return this.onMouseMove(e.originalEvent.touches[0]);
      };

      CreaturePicker.prototype.onTouchEnd = function(e) {
        return this.onMouseUp(e.originalEvent.touches[0]);
      };

      CreaturePicker.prototype.setDisabled = function(disabled) {
        var marker, _i, _len, _ref;
        this.disabled = disabled;
        if (this.disabled) {
          _ref = this.markers || [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            marker = _ref[_i];
            if (marker.selected) {
              marker.deselect();
            }
          }
        }
        if (this.disabled) {
          return this.selectionArea.addClass('disabled');
        } else {
          return this.selectionArea.removeClass('disabled');
        }
      };

      CreaturePicker.prototype.changeClassification = function(classification) {
        this.classification = classification;
        if (this.markers) {
          while (this.markers.length !== 0) {
            this.markers[0].release();
          }
        }
        this.markers = [];
        return this.resetStrays();
      };

      CreaturePicker.prototype.resetStrays = function() {
        var _ref, _ref1;
        if ((_ref = this.strayCircles) != null) {
          _ref.remove();
        }
        this.strayCircles = this.paper.set();
        if ((_ref1 = this.strayAxes) != null) {
          _ref1.remove();
        }
        return this.strayAxes = this.paper.set();
      };

      return CreaturePicker;

    })(Spine.Controller);
    return module.exports = CreaturePicker;
  });

}).call(this);
