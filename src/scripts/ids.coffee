define (require, exports, module) ->
  {dev} = require 'zooniverse/config'
  dev = true
  
  if dev
    ids =
      project: 'andromeda'
      workflow: '50533aa51a320e6c37000001'
      tutorialSubject: '4ff748f654558f75b1000002'
  else
    ids =
      project: 'andromeda'
      workflow: '50533aa51a320e6c37000001'
      tutorialSubject: '4fea1ca7c32dab27fa000002'

  module.exports = ids