define (require, exports, module) ->
  {dev} = require 'zooniverse/config'
  dev = true
  
  if dev
    ids =
      project: 'andromeda'
      workflow: '5052085f516bcb6b8a000003'
      tutorialSubject: '509935796aa0e064b6000001'
  else
    ids =
      project: 'andromeda'
      workflow: '5052085f516bcb6b8a000003'
      tutorialSubject: '509935796aa0e064b6000001'

  module.exports = ids