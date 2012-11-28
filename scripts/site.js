// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require, exports, module) {
    var $, App, Classifier, ImageFlipper, Profile, Project, Scoreboard, Sky, Subject, Workflow, config, current, devRefs, el, ids, name, reference, tutorialSteps, workflow, _i, _len, _ref, _results;
    $ = require('jQuery');
    config = require('zooniverse/config');
    ids = require('ids');
    App = require('zooniverse/controllers/App');
    Project = require('zooniverse/models/Project');
    Workflow = require('zooniverse/models/Workflow');
    Subject = require('zooniverse/models/Subject');
    Classifier = require('controllers/Classifier');
    tutorialSteps = require('tutorialSteps');
    Scoreboard = require('controllers/Scoreboard');
    Profile = require('controllers/Profile');
    ImageFlipper = require('controllers/ImageFlipper');
    Sky = require('controllers/Sky');
    workflow = new Workflow({
      id: ids.workflow,
      tutorialSubjects: new Subject({
        id: ids.tutorialSubject,
        location: {
          standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/tutorial.jpg",
          thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/tutorial.jpg"
        }
      })
    });
    config.set({
      name: 'Andromeda Project',
      slug: 'andromeda-project',
      description: 'Help find star clusters and galaxies in M31!',
      domain: 'andromedaproject.org',
      talkHost: 'http://talk.andromedaproject.org',
      googleAnalytics: 'UA-1224199-37'
    });
    config.set({
      app: new App({
        el: '#main',
        languages: ['en'],
        appName: 'Andromeda Project',
        projects: new Project({
          id: ids.project,
          workflows: workflow
        })
      })
    });
    config.set({
      sky: new Sky({
        el: '#banner'
      }),
      classifier: new Classifier({
        el: '#classifier',
        tutorialSteps: tutorialSteps,
        workflow: config.app.projects[0].workflows[0]
      }),
      profile: new Profile({
        el: '[data-page="profile"]'
      })
    });
    _ref = $('[data-image-flipper]');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      current = $(el).attr('data-image-flipper');
      new ImageFlipper({
        el: el,
        current: current
      });
    }
    window.bw = false;
    $('li.guideToggle').click(function() {
      if (window.bw === false) {
        window.bw = true;
        $('li.guideToggle').text("Show Color Images");
        return $('img.canToggle').each(function() {
          var src;
          src = $(this).attr('src').replace('color', 'F475W');
          return $(this).attr('src', src);
        });
      } else {
        window.bw = false;
        $('li.guideToggle').text("Show B/W Images");
        return $('img.canToggle').each(function() {
          var src;
          src = $(this).attr('src').replace('F475W', 'color');
          return $(this).attr('src', src);
        });
      }
    });
    $('img.canToggle').hover(function() {
      var src;
      if (window.bw === false) {
        src = $(this).attr('src').replace('color', 'F475W');
        return $(this).attr('src', src);
      } else {
        src = $(this).attr('src').replace('F475W', 'color');
        return $(this).attr('src', src);
      }
    }, function() {
      var src;
      if (window.bw === false) {
        src = $(this).attr('src').replace('F475W', 'color');
        return $(this).attr('src', src);
      } else {
        src = $(this).attr('src').replace('color', 'F475W');
        return $(this).attr('src', src);
      }
    });
    devRefs = {
      config: require('zooniverse/config'),
      API: require('zooniverse/API')
    };
    if (config.dev) {
      _results = [];
      for (name in devRefs) {
        reference = devRefs[name];
        _results.push(window[name] = reference);
      }
      return _results;
    }
  });

}).call(this);
