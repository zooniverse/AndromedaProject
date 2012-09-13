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
  
  Sample = require('sample')
  
  # Over ride fetchSubjects to pull subjects locally
  workflow = new Workflow
    id: ids.workflow

    tutorialSubjects: new Subject
        id: ids.tutorialSubject
        location:
          standard: "subjects/standard/tutorial.jpg"
          thumbnail: "subjects/standard/tutorial.jpg"
        coords: [0, 0]
        metadata:
          depth: 0
          altitude: 0
          heading: 0
          salinity: 0
          temperature: 0
          speed: 0
          mm_pix: 1
  
  # workflow.fetchSubjects = (group) ->
  #   workflow.trigger 'fetching-subjects'
  #   workflow.enough = new $.Deferred
  #   
  #   limit = workflow.queueLength - workflow.length
  # 
  #   # If there are enough subjects in the queue, resolve the deferred immediately.
  #   workflow.subjects = Sample.generate()
  #   if workflow.subjects.length > workflow.selectionLength
  #     workflow.enough.resolve workflow.subjects
  
  config.set
    name: 'Andromeda Project'
    slug: 'andromeda-project'
    description: 'Help find star clusters and galaxies in M31!'

    domain: 'andromedaproject.org'
    talkHost: 'http://talk.andromedaproject.org'

    googleAnalytics: 'UA-1224199-30'

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

    homeScoreboard: new Scoreboard
      el: '[data-page="home"] .scoreboard'

  for el in $('[data-image-flipper]')
    current = $(el).attr 'data-image-flipper'
    new ImageFlipper {el, current}

  devRefs =
    config: require 'zooniverse/config'
    API: require 'zooniverse/API'

  window[name] = reference for name, reference of devRefs if config.dev
