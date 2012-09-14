// Generated by CoffeeScript 1.3.3
(function() {

  require.config({
    paths: {
      base64: 'lib/base64',
      jquery: 'lib/jquery',
      jQuery: 'lib/zooniverse/blanks/jQuery',
      Spine: 'lib/spine',
      Leaflet: 'lib/leaflet',
      Raphael: 'lib/zooniverse/blanks/Raphael',
      soundManager: 'lib/soundmanager/soundmanager2',
      zooniverse: 'lib/zooniverse'
    },
    shim: {
      base64: {
        exports: 'base64'
      },
      jQuery: {
        deps: ['jquery'],
        exports: function($) {
          $.support.cors = true;
          return $.noConflict();
        }
      },
      Spine: {
        deps: ['jQuery'],
        exports: 'Spine'
      },
      Leaflet: {
        deps: ['jQuery'],
        exports: function($) {
          var head, styleTags;
          styleTags = '<link rel="stylesheet" href="styles/lib/leaflet/leaflet.css" />\n<!--[if lte IE 8]>\n    <link rel="stylesheet" href="styles/lib/leaflet/leaflet.ie.css" />\n<![endif]-->';
          head = $('head');
          if (!~head.html().indexOf('leaflet.css')) {
            head.prepend(styleTags);
          }
          return L;
        }
      },
      Raphael: {
        exports: function() {
          if (typeof Raphael === "undefined" || Raphael === null) {
            console.error('Raphael needs its own <script> tag before RequireJS.');
          }
          return Raphael;
        }
      },
      soundManager: {
        exports: function() {
          if (window.SM2_DEFER !== true) {
            throw new Error('window.SM2_DEFER must be true before loading SoundManager');
          }
          window.soundManager = new SoundManager();
          window.soundManager.url = 'scripts/lib/soundmanager/swf';
          window.soundManager.html5PollingInterval = 50;
          window.soundManager.debugMode = false;
          window.soundManager.beginDelayedInit();
          return window.soundManager;
        }
      }
    },
    deps: ['site']
  });

}).call(this);
