// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var MarkerIndicator, Raphael, Spine, style, template;
    Spine = require('Spine');
    Raphael = require('Raphael');
    template = require('views/MarkerIndicator');
    style = require('style');
    MarkerIndicator = (function(_super) {

      __extends(MarkerIndicator, _super);

      MarkerIndicator.prototype.species = '';

      MarkerIndicator.prototype.step = NaN;

      MarkerIndicator.prototype.circles = null;

      MarkerIndicator.prototype.paper = null;

      MarkerIndicator.prototype.template = template;

      MarkerIndicator.prototype.helpers = {
        fish: {
          image: 'images/indicator/fish.png',
          points: [
            {
              x: 7,
              y: 27
            }, {
              x: 183,
              y: 23
            }, {
              x: 56,
              y: 17
            }, {
              x: 57,
              y: 46
            }
          ]
        },
        galaxy: {
          image: 'images/indicator/galaxy.png',
          points: [
            {
              x: 35,
              y: 35
            }, {
              x: 50,
              y: 5
            }
          ]
        },
        cluster: {
          image: 'images/indicator/cluster.png',
          points: [
            {
              x: 40,
              y: 70
            }, {
              x: 40,
              y: 5
            }, {
              x: 5,
              y: 45
            }, {
              x: 75,
              y: 45
            }
          ]
        },
        crustacean: {
          image: 'images/indicator/crustacean.png',
          points: [
            {
              x: 70,
              y: 15
            }, {
              x: 70,
              y: 55
            }, {
              x: 5,
              y: 35
            }, {
              x: 130,
              y: 35
            }
          ]
        }
      };

      MarkerIndicator.prototype.elements = {
        'img': 'image',
        '.points': 'points'
      };

      function MarkerIndicator() {
        this.setStep = __bind(this.setStep, this);

        this.setSpecies = __bind(this.setSpecies, this);

        this.reset = __bind(this.reset, this);
        MarkerIndicator.__super__.constructor.apply(this, arguments);
        this.html(this.template);
        this.paper = Raphael(this.points.get(0), '100%', '100%');
      }

      MarkerIndicator.prototype.reset = function() {};

      MarkerIndicator.prototype.setSpecies = function(species) {
        var circle, coords, _i, _len, _ref, _ref1,
          _this = this;
        if (species === this.species) {
          return;
        }
        this.species = species;
        if ((_ref = this.circles) != null) {
          _ref.remove();
        }
        this.image.css({
          display: 'none'
        });
        this.step = -1;
        if (this.species in this.helpers) {
          this.image.attr('src', this.helpers[this.species].image);
          this.image.css({
            display: ''
          });
          this.image.one('load', function() {
            return _this.paper.setSize(_this.image.width(), _this.image.height());
          });
          this.circles = this.paper.set();
          _ref1 = this.helpers[this.species].points;
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            coords = _ref1[_i];
            circle = this.paper.circle();
            circle.attr(style.helperCircle);
            circle.attr({
              cx: coords.x,
              cy: coords.y,
              fill: style[this.species]
            });
            this.circles.push(circle);
          }
          return this.setStep(0);
        }
      };

      MarkerIndicator.prototype.setStep = function(step) {
        var _this = this;
        if (!this.species) {
          return;
        }
        step %= this.helpers[this.species].points.length;
        if (step === this.step) {
          return;
        }
        this.step = step;
        this.circles.attr(style.helperCircle);
        return this.circles[this.step].animate(style.helperCircle.active, 100, function() {
          return _this.circles[_this.step].animate(style.helperCircle, 100, function() {
            return _this.circles[_this.step].animate(style.helperCircle.active, 100);
          });
        });
      };

      return MarkerIndicator;

    })(Spine.Controller);
    return module.exports = MarkerIndicator;
  });

}).call(this);
