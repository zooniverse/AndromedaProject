define (require, exports, module) ->
  {dev} = require 'zooniverse/config'
  
  if dev
    ids =
      project: 'sea_floor'
      workflow: '4fa408de54558f3d6a000002'
      tutorialSubject: '4ff748f654558f75b1000002'
  else
    ids =
      project: 'sea_floor'
      workflow: '4fdf8fb3c32dab6c95000002'
      tutorialSubject: '4fea1ca7c32dab27fa000002'

  module.exports = ids