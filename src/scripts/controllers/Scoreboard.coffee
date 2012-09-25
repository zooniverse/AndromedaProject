define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'
  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  Classification = require 'zooniverse/models/Classification'

  SCOREBOARD_TEMPLATE = require 'views/Scoreboard'

  class Scoreboard extends Spine.Controller
    forUser: false

    template: SCOREBOARD_TEMPLATE

    elements:
      '.galaxy.score .count': 'galaxyCount'
      '.linear.score .count': 'starCount'
      '.cluster.score .count': 'clusterCount'
      '.ghost.score .count': 'ghostCount'
      '.classifications.score .count': 'classificationCount'

    constructor: ->
      super
      @html @template

      # User.bind 'sign-in', @update
      # Classification.bind 'persist', @update
      # delay @update

    update: =>
      return if @forUser and not User.current?

      url = "http://#{config.cartoUser}.cartodb.com/api/v2/sql?callback=?"

      query = 'SELECT ' +
        'SUM(ALL(clusters)) AS clusters, ' +
        'SUM(ALL(star)) AS star, ' +
        'SUM(ALL(galaxies)) AS galaxies, ' +
        'SUM(ALL(ghosts)) AS ghosts, ' +
        'COUNT(ALL(created_at)) AS classifications ' +
        "FROM #{config.cartoTable}"

      if @forUser and User.current?
        query += " where user_id='#{User.current.id}'"

      $.getJSON url, q: query, (response) =>
        @render response.rows[0]

    render: ({clusters, star, galaxies, ghosts, classifications}) =>
      @clusterCount.html clusters || 0
      @starCount.html star || 0
      @galaxyCount.html galaxies || 0
      @ghostCount.html ghosts || 0
      @classificationCount.html classifications || 0

  module.exports = Scoreboard
