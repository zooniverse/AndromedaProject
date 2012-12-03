// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, Annotation, Classification, Classifier, CreaturePicker, MarkerIndicator, Pager, TEMPLATE, User, ZooniverseClassifier, arraysMatch, config, delay, remove, _ref;
    $ = require('jQuery');
    config = require('zooniverse/config');
    _ref = require('zooniverse/util'), delay = _ref.delay, remove = _ref.remove, arraysMatch = _ref.arraysMatch;
    ZooniverseClassifier = require('zooniverse/controllers/Classifier');
    Classification = require('zooniverse/models/Classification');
    Annotation = require('zooniverse/models/Annotation');
    User = require('zooniverse/models/User');
    CreaturePicker = require('controllers/CreaturePicker');
    MarkerIndicator = require('controllers/MarkerIndicator');
    Pager = require('zooniverse/controllers/Pager');
    TEMPLATE = require('views/Classifier');
    Classifier = (function(_super) {

      __extends(Classifier, _super);

      Classifier.prototype.template = TEMPLATE;

      Classifier.prototype.picker = null;

      Classifier.prototype.indicator = null;

      Classifier.prototype.feedback = ["Well done", "Awesome", "Nice", "Congratulations"];

      Classifier.prototype.events = {
        'click .species .toggles button': 'changeSpecies',
        'click .species .other-creatures button': 'showArtifacts',
        'click .species .finished': 'finishSpecies',
        'click .favorite .create button': 'createFavorite',
        'click .favorite .destroy button': 'destroyFavorite',
        'click .talk [value="yes"]': 'goToTalk',
        'click .talk [value="no"]': 'nextSubjects',
        'click .favorite [value="no"]': 'nextSubjects',
        'click .tutorial-again': 'startTutorial',
        'click .feedback': 'showLabels',
        'click .toggle-subject': 'toggleSubject',
        'click .reset-subject': 'resetClassification',
        'click .show-hide': 'showHide'
      };

      Classifier.prototype.elements = {
        '.steps': 'steps',
        '.species .toggles button': 'speciesButtons',
        '.species .other-creatures [value="yes"]': 'otherYes',
        '.species .other-creatures [value="no"]': 'otherNo',
        '.species .finished': 'speciesFinishedButton',
        '.summary': 'summary',
        '.overlay': 'overlay',
        '.summary .favorite .create': 'favoriteCreation',
        '.summary .favorite .destroy': 'favoriteDestruction',
        '.feedback .box': 'feedbackBox'
      };

      function Classifier() {
        this.finishSpecies = __bind(this.finishSpecies, this);

        this.showHide = __bind(this.showHide, this);

        this.toggleSubject = __bind(this.toggleSubject, this);

        this.showLabels = __bind(this.showLabels, this);

        this.changeOther = __bind(this.changeOther, this);

        this.showArtifacts = __bind(this.showArtifacts, this);

        this.changeSpecies = __bind(this.changeSpecies, this);

        this.updateFavoriteButtons = __bind(this.updateFavoriteButtons, this);

        this.renderSpeciesPage = __bind(this.renderSpeciesPage, this);

        this.render = __bind(this.render, this);

        this.resetClassification = __bind(this.resetClassification, this);

        this.reset = __bind(this.reset, this);

        this.enableFinished = __bind(this.enableFinished, this);

        this.disableFinished = __bind(this.disableFinished, this);

        var pager, _i, _len, _ref1;
        Classifier.__super__.constructor.apply(this, arguments);
        this.indicator = new MarkerIndicator({
          el: this.el.find('.indicator'),
          classifier: this
        });
        this.picker = new CreaturePicker({
          el: this.el.find('.image'),
          classifier: this
        });
        this.picker.bind('change-selection', this.renderSpeciesPage);
        _ref1 = this.el.find('[data-page]').parent();
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          pager = _ref1[_i];
          new Pager({
            el: pager
          });
        }
        User.bind('sign-in', this.updateFavoriteButtons);
        this.picker.el.bind('create-half-axes-marker', this.disableFinished);
        this.picker.el.bind('create-axes-marker', this.enableFinished);
      }

      Classifier.prototype.disableFinished = function() {
        return $('button[class="finished"]').attr('disabled', 'disabled');
      };

      Classifier.prototype.enableFinished = function() {
        return $('button[class="finished"]').removeAttr('disabled');
      };

      Classifier.prototype.reset = function() {
        var _this = this;
        this.picker.reset();
        Classifier.__super__.reset.apply(this, arguments);
        this.otherSpeciesAnnotation = new Annotation({
          classification: this.classification
        });
        this.changeSpecies(null);
        this.steps.removeClass('finished');
        $('#toggleCol').text('B/W');
        return delay(500, function() {
          return _this.updateFavoriteButtons();
        });
      };

      Classifier.prototype.resetClassification = function(e) {
        e.preventDefault();
        return this.reset();
      };

      Classifier.prototype.render = function() {
        var active, item, _i, _len, _ref1;
        this.renderSpeciesPage();
        this.feedbackBox.hide();
        active = false;
        _ref1 = $('button[data-marker]');
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          item = _ref1[_i];
          if ($(item).hasClass('active')) {
            active = true;
            break;
          }
        }
        if (!active) {
          return $('button[value="cluster"]').click();
        }
      };

      Classifier.prototype.renderSpeciesPage = function() {
        var annotation, button, countElement, m, selectedMarker, _i, _len, _ref1;
        selectedMarker = ((function() {
          var _i, _len, _ref1, _results;
          _ref1 = this.picker.markers;
          _results = [];
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            m = _ref1[_i];
            if (m.selected) {
              _results.push(m);
            }
          }
          return _results;
        }).call(this))[0];
        if (selectedMarker) {
          this.speciesButtons.filter("[value='" + selectedMarker.annotation.value.species + "']").trigger('click');
        }
        this.speciesButtons.find('.count').html('0');
        _ref1 = this.classification.annotations;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          annotation = _ref1[_i];
          button = this.speciesButtons.filter("[value='" + annotation.value.species + "']");
          countElement = button.find('.count');
          countElement.html(parseInt(countElement.html(), 10) + 1);
        }
        if (!this.otherSpeciesAnnotation) {

        }
      };

      Classifier.prototype.updateFavoriteButtons = function() {
        var signedIn, tutorial;
        signedIn = User.current != null;
        tutorial = arraysMatch(this.workflow.selection, this.workflow.tutorialSubjects);
        return this.el.toggleClass('can-favorite', signedIn && !tutorial);
      };

      Classifier.prototype.changeSpecies = function(e) {
        var species, target;
        if (e == null) {
          e = {
            target: $('<input />')
          };
        }
        target = $(e.target);
        species = target.val();
        this.picker.selectedSpecies = species;
        this.picker.selectedMarkerType = target.data('marker');
        this.picker.setDisabled(!species);
        this.indicator.setSpecies(species);
        this.speciesButtons.removeClass('active');
        return target.addClass('active');
      };

      Classifier.prototype.showArtifacts = function(e) {
        var target;
        target = $(e.target);
        if (target.val() === "yes") {
          $('#artefact-list').slideDown();
        }
        if (target.val() === "no") {
          $('#artefact-list').slideUp();
        }
        if (target.val() === "yes") {
          this.otherSpeciesAnnotation.value.otherSpecies = 1;
        }
        if (target.val() === "no") {
          this.otherSpeciesAnnotation.value.otherSpecies = 0;
        }
        if (target.val() === "yes") {
          this.otherYes.addClass('active');
        }
        if (target.val() === "no") {
          this.otherNo.addClass('active');
        }
        if (target.val() === "no") {
          this.otherYes.removeClass('active');
        }
        if (target.val() === "yes") {
          this.otherNo.removeClass('active');
        }
        return this.speciesFinishedButton.removeAttr('disabled');
      };

      Classifier.prototype.changeOther = function(e) {
        var target, value;
        target = $(e.target);
        value = target.val();
        this.otherSpeciesAnnotation.value.otherSpecies = value;
        return this.classification.trigger('change');
      };

      Classifier.prototype.showLabels = function() {
        var m, _i, _len, _ref1, _results;
        _ref1 = this.picker.markers;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          m = _ref1[_i];
          m.label.show();
          _results.push(m.label.animate({
            opacity: 1
          }, 100));
        }
        return _results;
      };

      Classifier.prototype.toggleSubject = function(e) {
        var img, src, target;
        target = $(e.target);
        e.preventDefault();
        img = jQuery('.selection-area img');
        src = img.attr('src');
        if (src.indexOf("color") >= 0) {
          src = src.replace('color', 'F475W');
          target.text("Color");
        } else {
          src = src.replace('F475W', 'color');
          target.text("B/W");
        }
        return img.attr('src', src);
      };

      Classifier.prototype.showHide = function() {
        if ($('.show-hide').text() === 'Hide' && this.picker.markers.length > 0) {
          $('.show-hide').text('Show');
          return $('svg').hide();
        } else {
          $('.show-hide').text('Hide');
          return $('svg').show();
        }
      };

      Classifier.prototype.finishSpecies = function() {
        var anchor, annotation, center, centerPoint, context, coords, distance, height, nx, ny, points, radius, subject, synthetic, synthetics, width, words, x, x1, x2, xtext, y, y1, y2, _i, _j, _len, _len1, _ref1;
        $('svg').show();
        this.picker.setDisabled(true);
        this.steps.addClass('finished');
        subject = this.picker.classifier.workflow.selection[0];
        if (subject) {
          width = 240;
          height = 309;
          center = subject.metadata.center;
          if (center != null) {
            nx = parseFloat(center[0]);
            ny = parseFloat(center[1]);
            x = width * nx;
            y = height * ny;
            radius = 4;
            this.overlay[0].width = width;
            this.overlay[0].height = height;
            context = this.overlay[0].getContext('2d');
            context.beginPath();
            context.arc(x, y, radius, 0, 2 * Math.PI, false);
            context.fillStyle = "#FAFAFA";
            context.fill();
            context.lineWidth = 1;
            context.strokeStyle = "#505050";
            context.stroke();
            context.closePath();
            coords = subject.coords;
            if (coords) {
              this.feedbackBox.show();
              this.feedbackBox.find('.value:nth-child(2)').text("" + (coords[0].toFixed(3)));
              this.feedbackBox.find('.value:nth-child(5)').text("" + (coords[1].toFixed(3)));
              this.feedbackBox.css({
                top: "" + (y + 40) + "px",
                left: "" + (x + 20) + "px"
              });
            }
          }
          synthetics = subject.metadata.synthetic;
          if (synthetics) {
            if ('annotations' in this.classification) {
              _ref1 = this.classification.annotations;
              for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
                annotation = _ref1[_i];
                if ('value' in annotation) {
                  if ('species' in annotation.value) {
                    if (annotation.value.species === 'cluster') {
                      points = annotation.value.points;
                      centerPoint = points[0];
                      x1 = 725 * centerPoint.x;
                      y1 = 500 * centerPoint.y;
                      for (_j = 0, _len1 = synthetics.length; _j < _len1; _j++) {
                        synthetic = synthetics[_j];
                        x2 = parseFloat(synthetic.x);
                        y2 = 500 - parseFloat(synthetic.y);
                        distance = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
                        if (distance < 20) {
                          if (x2 > 500) {
                            xtext = x2 - pixradius - 8;
                            anchor = 'end';
                          } else {
                            xtext = x2 + pixradius + 8;
                            anchor = 'start';
                          }
                          this.picker.paper.circle(x2, y2, pixradius).attr({
                            'stroke': '#F1F1F1',
                            'stroke-width': 6
                          });
                          this.picker.paper.circle(x2, y2, pixradius).attr({
                            'stroke': '#000000',
                            'stroke-width': 3
                          });
                          words = this.feedback[Math.floor(Math.random() * this.feedback.length)];
                          this.picker.paper.text(xtext, y2, "" + words + ", you found a synthetic cluster!").attr("font", "bold 11px 'Open Sans', sans-serif").attr("text-anchor", anchor).attr({
                            "fill": "#F1F1F1"
                          });
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          return this.saveClassification();
        }
      };

      return Classifier;

    })(ZooniverseClassifier);
    return module.exports = Classifier;
  });

}).call(this);
