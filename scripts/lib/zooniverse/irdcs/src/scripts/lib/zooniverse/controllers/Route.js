// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function(require, exports, module) {
    var $, Route, remove;
    $ = require('jQuery');
    remove = require('zooniverse/util').remove;
    Route = (function() {
      var _this = this;

      Route.routes = [];

      Route.lastCheckedHash = '';

      Route.checkHash = function(hash) {
        var params, route, _i, _len, _ref;
        if (typeof hash !== 'string') {
          hash = location.hash.slice(2);
        }
        if (~location.hash.indexOf('...')) {
          location.hash = Route.replaceEllipses(location.hash, Route.lastCheckedHash);
          return;
        }
        _ref = Route.routes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          route = _ref[_i];
          params = route.test(hash);
          if (params != null) {
            route.handler.apply(route, params);
          }
        }
        return Route.lastCheckedHash = hash;
      };

      Route.replaceEllipses = function(hash) {
        var hashSegment, hashSegments, i, pathSegments, _i, _len;
        hashSegments = hash.split('/');
        pathSegments = this.lastCheckedHash.split('/');
        for (i = _i = 0, _len = hashSegments.length; _i < _len; i = ++_i) {
          hashSegment = hashSegments[i];
          if (hashSegment === '...') {
            hashSegments[i] = pathSegments[i];
          }
        }
        return hashSegments.join('/');
      };

      Route.prototype.path = '';

      Route.prototype.handler = null;

      function Route(path, handler) {
        this.path = path;
        this.handler = handler;
        this.destroy = __bind(this.destroy, this);

        this.test = __bind(this.test, this);

        this.constructor.routes.push(this);
        this.constructor.routes.sort(function(a, b) {
          return a.path.split('/').length > b.path.split('/').length;
        });
      }

      Route.prototype.test = function(hash) {
        var hashSegments, i, params, pathSegment, pathSegments, _i, _len;
        pathSegments = this.path.split('/');
        hashSegments = hash.split('/');
        if (!(hashSegments.length >= pathSegments.length)) {
          return;
        }
        params = [];
        for (i = _i = 0, _len = pathSegments.length; _i < _len; i = ++_i) {
          pathSegment = pathSegments[i];
          if (pathSegment.charAt(0) === ':') {
            params.push(hashSegments[i]);
          } else if (hashSegments[i] === pathSegments[i]) {
            continue;
          } else {
            return;
          }
        }
        return params;
      };

      Route.prototype.destroy = function() {
        return remove(this, {
          from: this.constructor.routes
        });
      };

      $(window).on('hashchange', Route.checkHash);

      $(function() {
        return Route.checkHash();
      });

      return Route;

    }).call(this);
    return module.exports = Route;
  });

}).call(this);
