define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  ids = require 'ids'

  App = require 'zooniverse/controllers/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'
  Scoreboard = require 'controllers/Scoreboard'
  Profile = require 'controllers/Profile'
  ImageFlipper = require 'controllers/ImageFlipper'

  Sky = require 'controllers/Sky'
  
  # Over ride fetchSubjects to pull subjects locally
  workflow = new Workflow
    id: ids.workflow

    tutorialSubjects: new Subject
        id: ids.tutorialSubject
        location:
          standard: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/standard/color/tutorial.jpg"
          thumbnail: "http://www.andromedaproject.org.s3.amazonaws.com/subjects/thumbnail/color/tutorial.jpg"
        coords: [11.318979, 41.958249]
        metadata:          
          subimg: 'B17-F16_tutorial',
          center: ["0.4701", "0.3234"]
  
  config.set
    name: 'Andromeda Project'
    slug: 'andromeda-project'
    description: 'Help find star clusters and galaxies in M31!'

    domain: 'andromedaproject.org'
    talkHost: 'http://talk.andromedaproject.org'

    googleAnalytics: 'UA-1224199-37'

  config.set
    app: new App
      el: '#main'
      languages: ['en']
      appName: 'Andromeda Project'
      projects: new Project
        id: ids.project
        workflows: workflow

  config.set
    sky: new Sky
      el: '#banner'
    
    classifier: new Classifier
      el: '#classifier'
      tutorialSteps: tutorialSteps
      workflow: config.app.projects[0].workflows[0]

    profile: new Profile
      el: '[data-page="profile"]'

  for el in $('[data-image-flipper]')
    current = $(el).attr 'data-image-flipper'
    new ImageFlipper {el, current}

  window.bw = false

  $('li.guideToggle').click( ->
    if window.bw == false
      window.bw = true
      $('li.guideToggle').text("Show Color Images")
      $('img.canToggle').each( ->
        src = $(this).attr('src').replace('color', 'F475W')
        $(this).attr('src', src)
      )
    else
      window.bw = false
      $('li.guideToggle').text("Show B/W Images")
      $('img.canToggle').each( ->
        src = $(this).attr('src').replace('F475W', 'color')
        $(this).attr('src', src)
      )
  )
  
  $('img.canToggle').hover(
    ->
      if window.bw == false
        src = $(this).attr('src').replace('color', 'F475W')
        $(this).attr('src', src)
      else
        src = $(this).attr('src').replace('F475W', 'color')
        $(this).attr('src', src)
    ,->
      if window.bw == false
        src = $(this).attr('src').replace('F475W', 'color')
        $(this).attr('src', src)
      else
        src = $(this).attr('src').replace('color', 'F475W')
        $(this).attr('src', src)
  )

  devRefs =
    config: require 'zooniverse/config'
    API: require 'zooniverse/API'

  window[name] = reference for name, reference of devRefs if config.dev
