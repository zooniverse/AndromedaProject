// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var L, Sky, Spine;
    Spine = require('Spine');
    L = require('Leaflet');
    Sky = (function(_super) {

      __extends(Sky, _super);

      Sky.prototype.mapOptions = {
        attributionControl: true,
        worldCopyJump: false
      };

      function Sky() {
        this.createMap = __bind(this.createMap, this);

        var _ref;
        Sky.__super__.constructor.apply(this, arguments);
        jQuery(window).bind('hashchange', this.createMap);
        if ((_ref = window.location['hash']) === '' || _ref === '#!/home') {
          this.createMap();
        }
      }

      Sky.prototype.createMap = function() {
        var layer, _ref;
        if (this.map != null) {
          return;
        }
        if ((_ref = window.location['hash']) !== '' && _ref !== '#!/home') {
          return;
        }
        this.map = L.map('banner', this.mapOptions).setView([14, 0], 2);
        this.map.attributionControl.setPrefix('');
        layer = L.tileLayer('/tiles/#{tilename}.jpg', {
          minZoom: 2,
          maxZoom: 8,
          attribution: 'Robert Gendler - The Andromeda Galaxy (M31) &copy; 2005',
          noWrap: true
        });
        layer.getTileUrl = function(tilePoint) {
          var convertTileUrl, url, zoom;
          zoom = this._getZoomForUrl();
          convertTileUrl = function(x, y, s, zoom) {
            var d, e, f, g, pixels;
            pixels = Math.pow(2, zoom);
            d = (x + pixels) % pixels;
            e = (y + pixels) % pixels;
            f = "t";
            g = 0;
            while (g < zoom) {
              pixels = pixels / 2;
              if (e < pixels) {
                if (d < pixels) {
                  f += "q";
                } else {
                  f += "r";
                  d -= pixels;
                }
              } else {
                if (d < pixels) {
                  f += "t";
                  e -= pixels;
                } else {
                  f += "s";
                  d -= pixels;
                  e -= pixels;
                }
              }
              g++;
            }
            return {
              x: x,
              y: y,
              src: f,
              s: s
            };
          };
          url = convertTileUrl(tilePoint.x, tilePoint.y, 1, zoom);
          return "http://www.andromedaproject.org.s3.amazonaws.com/alpha/tiles/" + url.src + ".jpg";
        };
        return layer.addTo(this.map);
      };

      return Sky;

    })(Spine.Controller);
    return module.exports = Sky;
  });

}).call(this);
