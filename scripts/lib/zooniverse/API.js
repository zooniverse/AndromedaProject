// Generated by CoffeeScript 1.3.3
(function() {
  var __slice = [].slice;

  define(function(require, exports, module) {
    var Proxy, del, get, getJSON, idOf, post;
    Proxy = require('zooniverse/Proxy');
    get = Proxy.get, post = Proxy.post, del = Proxy.del, getJSON = Proxy.getJSON;
    idOf = function(thing) {
      return (thing != null ? thing.id : void 0) || thing;
    };
    return module.exports = {
      get: get,
      post: post,
      del: del,
      getJSON: getJSON,
      Proxy: Proxy,
      signUp: function() {
        var andThen, email, password, project, username, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, username = _arg.username, email = _arg.email, password = _arg.password;
        return getJSON.apply(null, ["/projects/" + (idOf(project)) + "/signup", {
          username: username,
          email: email,
          password: password
        }].concat(__slice.call(andThen)));
      },
      checkCurrent: function() {
        var andThen, project, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project;
        return getJSON.apply(null, ["/projects/" + (idOf(project)) + "/current_user"].concat(__slice.call(andThen)));
      },
      logIn: function() {
        var andThen, password, project, username, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, username = _arg.username, password = _arg.password;
        return getJSON.apply(null, ["/projects/" + (idOf(project)) + "/login", {
          username: username,
          password: password
        }].concat(__slice.call(andThen)));
      },
      logOut: function() {
        var andThen, password, project, username, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, username = _arg.username, password = _arg.password;
        return getJSON.apply(null, ["/projects/" + (idOf(project)) + "/login", {
          username: username,
          password: password
        }].concat(__slice.call(andThen)));
      },
      fetchSubjects: function() {
        var andThen, group, limit, path, project, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, group = _arg.group, limit = _arg.limit;
        path = "/projects/" + (idOf(project));
        if (group) {
          path += "/groups/" + (idOf(group));
        }
        path += "/subjects";
        return get.apply(null, [path, {
          limit: limit
        }].concat(__slice.call(andThen)));
      },
      fetchFavorites: function() {
        var andThen, project, user, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, user = _arg.user;
        return get.apply(null, ["/projects/" + (idOf(project)) + "/users/" + (idOf(user)) + "/favorites"].concat(__slice.call(andThen)));
      },
      createFavorite: function() {
        var andThen, path, project, subject, subjects, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, subjects = _arg.subjects;
        path = "/projects/" + (idOf(project)) + "/favorites";
        return post.apply(null, [path, {
          favorite: {
            subject_ids: (function() {
              var _i, _len, _results;
              _results = [];
              for (_i = 0, _len = subjects.length; _i < _len; _i++) {
                subject = subjects[_i];
                _results.push(idOf(subject));
              }
              return _results;
            })()
          }
        }].concat(__slice.call(andThen)));
      },
      destroyFavorite: function() {
        var andThen, favorite, project, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, favorite = _arg.favorite;
        return del.apply(null, ["/projects/" + (idOf(project)) + "/favorites/" + (idOf(favorite))].concat(__slice.call(andThen)));
      },
      fetchRecents: function() {
        var andThen, project, user, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, user = _arg.user;
        return get.apply(null, ["/projects/" + (idOf(project)) + "/users/" + (idOf(user)) + "/recents"].concat(__slice.call(andThen)));
      },
      saveClassification: function() {
        var andThen, annotations, path, project, subjects, workflow, _arg;
        _arg = arguments[0], andThen = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        project = _arg.project, workflow = _arg.workflow, subjects = _arg.subjects, annotations = _arg.annotations;
        path = "/projects/" + project + "/workflows/" + workflow + "/classifications";
        return post.apply(null, [path, {
          classification: {
            subject_ids: subjects
          },
          annotations: annotations
        }].concat(__slice.call(andThen)));
      }
    };
  });

}).call(this);