Spine     = require('spine')
Home      = require('controllers/Home')
Classify  = require('controllers/Classify')
Science   = require('controllers/Science')

class Main extends Spine.Stack
  el: '#main'
  
  controllers:
    home      : Home
    classify  : Classify
    science   : Science
  
  default: 'home'
  
  routes:
    '/'         : 'home'
    '/classify' : 'classify'
    '/science'  : 'science'

module.exports = Main