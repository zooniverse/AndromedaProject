define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'
  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  ZooniverseProfile = require 'zooniverse/controllers/Profile'
  Scoreboard = require 'controllers/Scoreboard'

  TEMPLATE = require 'views/Profile'
  favoriteTemplate = require 'views/ProfileFavorite'
  recentTemplate = require 'views/ProfileRecent'

  class Profile extends ZooniverseProfile
    template: TEMPLATE
    favoriteTemplate: favoriteTemplate
    recentTemplate: recentTemplate

    userLayer: null
    scoreboard: null

    events: $.extend
      'click .sign-out': 'signOut'
      ZooniverseProfile::events

    elements: $.extend
      '.summary .username': 'usernameContainer'
      '.summary .scoreboard': 'scoreboardContainer'
      ZooniverseProfile::elements

    constructor: ->
      super

      @scoreboard = new Scoreboard
        el: @scoreboardContainer
        forUser: true

    userChanged: =>
      super

      if User.current?
        @usernameContainer.html User.current.name

    signOut: (e) =>
      e.preventDefault()
      User.signOut()

  module.exports = Profile
