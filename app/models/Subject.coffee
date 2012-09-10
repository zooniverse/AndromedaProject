Config      = require('lib/config')
Api         = require('zooniverse/lib/api')
BaseSubject = require('zooniverse/lib/models/subject')

class Subject extends BaseSubject
  @configure 'Subject', 'zooniverse_id'
  
  projectName: 'andromeda_project'
  
  constructor: ->
    super
    @location = 'tmp/B09-F11_1.jpg'
    
module.exports = Subject