require('lib/setup')

Config      = require('lib/config')
Spine       = require('spine')
Api         = require('zooniverse/lib/api')
Navigation  = require('controllers/Navigation')
Main        = require('controllers/Main')
TopBar      = require 'zooniverse/lib/controllers/top_bar'

class App extends Spine.Controller
  constructor: ->
    super
    
    # Api.init host: Config.apiHost
    # @topBar = new TopBar
    #   el: '.zooniverse-top-bar'
    #   languages:
    #     en: 'English'
    #   app: 'andromeda_project'
    
    @navigation = new Navigation
    @main = new Main
    
    @append @navigation.active(), @main
    Spine.Route.setup()
    
module.exports = App