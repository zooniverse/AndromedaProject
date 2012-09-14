require.config
  paths:
    base64: 'lib/base64'
    jquery: 'lib/jquery'
    # jQuery explicitly IDs its module as "jquery", which is a .
    # We'll have it load a blank file and shim it to refer to the jQuery function.
    jQuery: 'lib/zooniverse/blanks/jQuery'
    Spine: 'lib/spine'
    Leaflet: 'lib/leaflet'
    # Raphael has a fit if a "require" function is present.
    # Make sure it's loaded in its own script tag before RequireJS.
    # Again we'll use a blank file and a shim to refer to it.
    Raphael: 'lib/zooniverse/blanks/Raphael'
    soundManager: 'lib/soundmanager/soundmanager2'
    zooniverse: 'lib/zooniverse'

  shim:
    base64:
      exports: 'base64'

    jQuery:
      deps: ['jquery']
      exports: ($) ->
        $.support.cors = true
        $.noConflict()

    Spine:
      deps: ['jQuery']
      exports: 'Spine'

    Leaflet:
      deps: ['jQuery']
      exports: ($) ->
        styleTags = '''
          <link rel="stylesheet" href="styles/lib/leaflet/leaflet.css" />
          <!--[if lte IE 8]>
              <link rel="stylesheet" href="styles/lib/leaflet/leaflet.ie.css" />
          <![endif]-->
        '''

        head = $('head')
        head.prepend styleTags unless ~head.html().indexOf 'leaflet.css'

        L # Leaflet goes by "L". Its noConflict method is broken as of 3.1.

    Raphael:
      exports: ->
        console.error 'Raphael needs its own <script> tag before RequireJS.' unless Raphael?
        Raphael

    soundManager:
      exports: ->
        unless window.SM2_DEFER is true
          throw new Error 'window.SM2_DEFER must be true before loading SoundManager'

        window.soundManager = new SoundManager()
        window.soundManager.url = 'scripts/lib/soundmanager/swf'
        window.soundManager.preferFlash = false
        window.soundManager.flashLoadTimeout = 0 # Wait forever.
        window.soundManager.html5PollingInterval = 50
        window.soundManager.debugMode = false
        window.soundManager.beginDelayedInit()

        window.soundManager

  deps: ['site']
