// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(function(require, exports, module) {
    var $, API, Spine, Subject, User, Workflow;
    Spine = require('Spine');
    $ = require('jQuery');
    User = require('zooniverse/models/User');
    API = require('zooniverse/API');
    Subject = require('zooniverse/models/Subject');
    Workflow = (function(_super) {

      __extends(Workflow, _super);

      Workflow.include(Spine.Events);

      Workflow.prototype.queueLength = 5;

      Workflow.prototype.selectionLength = 1;

      Workflow.prototype.project = null;

      Workflow.prototype.subjects = null;

      Workflow.prototype.tutorialSubjects = null;

      Workflow.prototype.selection = null;

      function Workflow(params) {
        var property, subject, value, _i, _len, _ref, _ref1, _ref2, _ref3,
          _this = this;
        if (params == null) {
          params = {};
        }
        this.selectTutorial = __bind(this.selectTutorial, this);

        this.selectNext = __bind(this.selectNext, this);

        this.fetchSubjects = __bind(this.fetchSubjects, this);

        for (property in params) {
          if (!__hasProp.call(params, property)) continue;
          value = params[property];
          this[property] = value;
        }
        if ((_ref = this.subjects) == null) {
          this.subjects = [];
        }
        if (!(this.subjects instanceof Array)) {
          this.subjects = [this.subjects];
        }
        if ((_ref1 = this.tutorialSubjects) == null) {
          this.tutorialSubjects = [];
        }
        if (!(this.tutorialSubjects instanceof Array)) {
          this.tutorialSubjects = [this.tutorialSubjects];
        }
        _ref2 = this.subjects.concat(this.tutorialSubjects);
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          subject = _ref2[_i];
          subject.workflow = this;
        }
        if ((_ref3 = this.selection) == null) {
          this.selection = [];
        }
        User.bind('sign-in', function() {
          console.log('Workflow detected sign in');
          if (User.current != null) {
            while (_this.subjects.length !== 0) {
              _this.subjects.pop();
            }
          }
          return _this.fetchSubjects().done(function() {
            var _ref4;
            if ((_ref4 = User.current) != null ? _ref4.tutorialDone : void 0) {
              return _this.selectNext();
            } else {
              return _this.selectTutorial();
            }
          });
        });
      }

      Workflow.prototype.fetchSubjects = function(group) {
        var currentSubjectIDs, fetch, limit, subject,
          _this = this;
        this.trigger('fetching-subjects');
        this.enough = new $.Deferred;
        limit = this.queueLength - this.subjects.length;
        if (this.subjects.length > this.selectionLength) {
          this.enough.resolve(this.subjects);
        }
        if (limit !== 0) {
          console.log('Workflow fetching subjects...', 'Need:', this.queueLength, 'have:', this.subjects.length, 'fetching:', limit);
          currentSubjectIDs = (function() {
            var _i, _len, _ref, _results;
            _ref = this.subjects;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              subject = _ref[_i];
              _results.push(subject.id);
            }
            return _results;
          }).call(this);
          fetch = API.fetchSubjects({
            project: this.project,
            group: group,
            limit: limit
          });
          fetch.done(function(response) {
            var img, rawSubject, src, _i, _len, _ref;
            for (_i = 0, _len = response.length; _i < _len; _i++) {
              rawSubject = response[_i];
              if (rawSubject == null) {
                continue;
              }
              if (_ref = rawSubject.id, __indexOf.call(currentSubjectIDs, _ref) >= 0) {
                continue;
              }
              subject = Subject.fromJSON(rawSubject);
              subject.workflow = _this;
              _this.subjects.push(subject);
              src = subject.location.standard;
              if (src == null) {
                src = subject.location.image;
              }
              if (src) {
                img = $("<img src='" + src + "' />");
                img.css({
                  height: 0,
                  opacity: 0,
                  position: 'absolute',
                  width: 0
                });
                img.appendTo('body');
              }
            }
            _this.trigger('fetch-subjects', _this.subjects);
            if (!_this.enough.isResolved()) {
              return _this.enough.resolve(_this.subjects);
            }
          });
        }
        return this.enough.promise();
      };

      Workflow.prototype.selectNext = function() {
        console.log('Workflow changing selection');
        if (this.subjects.length >= this.selectionLength) {
          this.selection = this.subjects.splice(0, this.selectionLength);
          return this.trigger('change-selection', this.selection);
        } else {
          return this.trigger('selection-error', this.selection);
        }
      };

      Workflow.prototype.selectTutorial = function() {
        var _ref;
        if (!(this.tutorialSubjects.length > 0)) {
          return;
        }
        (_ref = this.subjects).unshift.apply(_ref, this.tutorialSubjects);
        this.selectNext();
        return this.trigger('select-tutorial');
      };

      return Workflow;

    })(Spine.Module);
    return module.exports = Workflow;
  });

}).call(this);