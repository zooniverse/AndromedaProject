// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, API, Spine, User, base64, remove;
    Spine = require('Spine');
    $ = require('jQuery');
    base64 = require('base64');
    remove = require('zooniverse/util').remove;
    API = require('zooniverse/API');
    User = (function(_super) {

      __extends(User, _super);

      User.extend(Spine.Events);

      User.include(Spine.Events);

      User.project = 'PROJECT_NOT_SPECIFIED';

      User.current = null;

      User.currentChecked = false;

      User.fromJSON = function(raw) {
        var _ref;
        return new User({
          id: raw.id,
          zooniverseID: raw.zooniverse_id,
          apiKey: raw.api_key,
          name: raw.name,
          tutorialDone: ((_ref = raw.project) != null ? _ref.tutorial_done : void 0) || false
        });
      };

      User.checkCurrent = function(project) {
        User.project = project;
        return API.checkCurrent({
          project: User.project
        }, function(response) {
          if (response.success) {
            User.signIn(User.fromJSON(response));
          } else {
            User.signOut();
          }
          return User.currentChecked = true;
        });
      };

      User.signUp = function(_arg) {
        var email, password, result, signUp, username;
        username = _arg.username, email = _arg.email, password = _arg.password;
        result = new $.Deferred;
        signUp = API.signUp({
          project: User.project,
          username: username,
          email: email,
          password: password
        });
        signUp.done(function(response) {
          if (response.success) {
            User.signIn(User.fromJSON(response));
            return result.resolve(User.current);
          } else {
            return result.reject(response.message);
          }
        });
        signUp.fail(function(response) {
          return result.reject('There was an error connecting to the server! The development team has been informed. Please try again later.');
        });
        return result.promise();
      };

      User.authenticate = function(_arg) {
        var password, result, username;
        username = _arg.username, password = _arg.password;
        result = new $.Deferred;
        API.logIn({
          project: User.project,
          username: username,
          password: password
        }, function(response) {
          if (response.success) {
            User.signIn(User.fromJSON(response));
            return result.resolve(User.current);
          } else {
            User.trigger('authentication-error', response.message);
            return result.reject(response.message);
          }
        });
        return result.promise();
      };

      User.signIn = function(user) {
        if (user === User.current && User.currentChecked) {
          return;
        }
        User.current = user;
        return User.trigger('sign-in', User.current);
      };

      User.deauthenticate = function() {
        return API.getJSON("/projects/" + User.project.id + "/logout", function() {
          delete API.Proxy.headers['Authorization'];
          return User.signOut();
        });
      };

      User.signOut = function() {
        return User.signIn(null);
      };

      User.prototype.zooniverseID = '';

      User.prototype.name = '';

      User.prototype.apiKey = '';

      User.prototype.tutorialDone = '';

      User.prototype.favorites = null;

      User.prototype.recents = null;

      function User(params) {
        var auth, property, value, _ref, _ref1;
        if (params == null) {
          params = {};
        }
        this.remove = __bind(this.remove, this);

        this.add = __bind(this.add, this);

        for (property in params) {
          if (!__hasProp.call(params, property)) continue;
          value = params[property];
          this[property] = value;
        }
        if ((_ref = this.favorites) == null) {
          this.favorites = [];
        }
        if ((_ref1 = this.recents) == null) {
          this.recents = [];
        }
        auth = base64.encode("" + this.name + ":" + this.apiKey);
        API.Proxy.headers['Authorization'] = "Basic " + auth;
      }

      User.prototype.add = function(map) {
        var name, thing, _ref;
        for (name in map) {
          if (!__hasProp.call(map, name)) continue;
          thing = map[name];
          if ((_ref = this["" + name + "s"]) != null) {
            _ref.push(thing);
          }
          this.trigger("add-" + name, thing);
          this.constructor.trigger("add-" + name, this, thing);
        }
        this.trigger('change');
        return this.constructor.trigger('change', this);
      };

      User.prototype.remove = function(map) {
        var name, thing;
        for (name in map) {
          if (!__hasProp.call(map, name)) continue;
          thing = map[name];
          remove(thing, {
            from: this["" + name + "s"]
          });
          this.trigger("remove-" + name, thing);
          this.constructor.trigger("remove-" + name, this, thing);
        }
        this.trigger('change');
        return this.constructor.trigger('change', this);
      };

      return User;

    }).call(this, Spine.Module);
    return module.exports = User;
  });

}).call(this);
