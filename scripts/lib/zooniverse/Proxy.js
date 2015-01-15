// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  define(function(require, exports, module) {
    var $, Proxy, Spine, config, remove;
    Spine = require('Spine');
    $ = require('jQuery');
    config = require('zooniverse/config');
    remove = require('zooniverse/util').remove;
    if (!config.apiHost) {
      throw new Error('zooniverse/Proxy needs config.apiHost');
    }
    if (!config.proxyPath) {
      throw new Error('zooniverse/Proxy needs config.proxyPath');
    }
    Proxy = (function(_super) {
      var _this = this;

      __extends(Proxy, _super);

      function Proxy() {
        return Proxy.__super__.constructor.apply(this, arguments);
      }

      Proxy.extend(Spine.Events);

      Proxy.iframe = $("<iframe src='" + config.apiHost + config.proxyPath + "'></iframe>");

      Proxy.iframe.css({
        display: 'none'
      });

      Proxy.iframe.appendTo('body');

      Proxy.external = Proxy.iframe.get(0).contentWindow;

      Proxy.ready = false;

      Proxy.readyDaisyChain = [new $.Deferred];

      Proxy.requests = {
        READY: new $.Deferred(function(deferred) {
          return deferred.always(function() {
            Proxy.ready = true;
            Proxy.readyDaisyChain[0].resolve();
            return remove(Proxy.readyDaisyChain[0], {
              from: Proxy.readyDaisyChain
            });
          });
        })
      };

      Proxy.headers = {};

      Proxy.postMessage = function(message) {
        return Proxy.external.postMessage(JSON.stringify(message), config.apiHost);
      };

      Proxy.request = function(type, url, data, done, fail) {
        var deferred, id, message;
        if (typeof data === 'function') {
          fail = done;
          done = data;
          data = null;
        }
        id = Math.floor(Math.random() * 99999999);
        deferred = new $.Deferred(function() {
          return this.then(done, fail);
        });
        message = {
          id: id,
          type: type,
          url: url,
          data: data,
          headers: Proxy.headers
        };
        if (Proxy.ready) {
          Proxy.postMessage(message);
        } else {
          Proxy.readyDaisyChain.slice(-1)[0].always(function() {
            Proxy.postMessage(message);
            return remove(deferred, {
              from: Proxy.readyDaisyChain
            });
          });
          Proxy.readyDaisyChain.push(deferred);
        }
        Proxy.requests[id] = deferred;
        deferred.always(function() {
          return delete Proxy.requests[id];
        });
        return deferred;
      };

      Proxy.get = function() {
        return Proxy.request.apply(Proxy, ['get'].concat(__slice.call(arguments)));
      };

      Proxy.post = function() {
        return Proxy.request.apply(Proxy, ['post'].concat(__slice.call(arguments)));
      };

      Proxy["delete"] = function() {
        return Proxy.request.apply(Proxy, ['delete'].concat(__slice.call(arguments)));
      };

      Proxy.del = function() {
        return Proxy.request.apply(Proxy, ['delete'].concat(__slice.call(arguments)));
      };

      Proxy.getJSON = function() {
        return Proxy.request.apply(Proxy, ['getJSON'].concat(__slice.call(arguments)));
      };

      $(window).on('message', function(_arg) {
        var e, failure, id, response, _ref;
        e = _arg.originalEvent;
        if (e.origin !== config.apiHost) {
          return;
        }
        _ref = JSON.parse(e.data), id = _ref.id, failure = _ref.failure, response = _ref.response;
        return Proxy.requests[id][!failure && 'resolve' || 'reject'](response);
      });

      return Proxy;

    }).call(this, Spine.Module);
    return module.exports = Proxy;
  });

}).call(this);
