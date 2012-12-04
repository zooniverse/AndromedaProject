define (require, exports, module) ->
  {dev} = require 'zooniverse/config'
  dev = true
  
  if dev
    ids =
      project: 'andromeda'
      workflow: '50be4f973ae7409761000001'
      tutorialSubject: '50b781751a320e4aac000001'
  else
    ids =
      project: 'andromeda'
      workflow: '50be4f973ae7409761000001'
      tutorialSubject: '50b781751a320e4aac000001'

  module.exports = ids