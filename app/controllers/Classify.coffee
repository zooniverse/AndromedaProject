Spine   = require('spine')
Subject = require('models/Subject')

class Classify extends Spine.Controller
  constructor: ->
    super
    @subject = new Subject()
    console.log @subject
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @isActive()
    @html require('views/classify')(@subject)


module.exports = Classify