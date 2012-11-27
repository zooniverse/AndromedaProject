define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [

    new Step
      heading: 'Welcome to the Andromeda Project!'
      content: [
        'This tutorial will show you how to use this site. Just read each step and follow any instructions.'
      ]
      continueText: 'Begin'
      style: width: 450
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      block: '.options'

    new Step
      heading: 'Identify Star Clusters'
      content: [
        'Star clusters are compact groups of many stars. They usually appear blue, but some will look orange if they are old or dusty.'
        'Let\' mark the two clusters in this image.'
      ]
      continueText: 'Next'
      style: width: 450
      attach: to: '.creature-picker'
      block: '.options'
    
    new Step
      heading: 'Identify Star Clusters'
      content: [
        'The button "star cluster" is selected by default when you begin.'
      ]
      attach: x: 'right', to: '[value="cluster"]', at: x: -0.05
      style: width: 340
      continueText: 'Next'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="cluster"]), .species .finished .other-creatures'
      
    new Step
      heading: 'Mark Star Clusters'
      content: [
        'Mark the cluster by clicking in the center then dragging out until the majority of the cluster is enclosed.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 0.24, y: 0.7
      style: width: 400
      onEnter: =>
        jQuery("#classifier .selection-area svg").attr('id', 'svg')
        svgDocument = document.getElementById('svg')
        shape = document.createElementNS("http://www.w3.org/2000/svg","circle")
        shape.setAttributeNS(null, "class", "cluster1")
        shape.setAttributeNS(null, "cx", 110)
        shape.setAttributeNS(null, "cy", 350)
        shape.setAttributeNS(null, "r", 30)
        shape.setAttributeNS(null, "stroke", "white")
        shape.setAttributeNS(null, "stroke-width", 2)
        shape.setAttributeNS(null, "fill", "none")
        document.getElementById('svg').appendChild(shape)
        jQuery(".cluster1").fadeOut(1000)
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Mark Star Clusters'
      content: [
        'Now let\'s mark the other, fainter cluster.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 0.23, y: 0.22
      style: width: 240
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Identifying Background Galaxies'
      content: [
        'On this site we are looking at the disc of the Andromeda galaxy.'
        'Distant galaxies sometimes shine through. They appear fuzzy and they vary in size.'
        'Choose "galaxy" from the species list to mark them.'
      ]
      attach: x: 'right', to: '[value="galaxy"]', at: x: -0.05
      style: width: 460
      nextOn: click: '.species [value="galaxy"]'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="galaxy"]), .species .finished .other-creatures'

    new Step
      heading: 'Mark Background Galaxies'
      content: [
        'Mark the galaxy by clicking in the center then dragging out until the majority is enclosed (just like the star clusters).'
      ]
      style: width: 320
      attach: x: 'left', to: '.creature-picker', at: x: 0.38, y: 0.62
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'
      
    new Step
      heading: 'Mark Background Galaxies'
      content: [
        'Now let\'s mark the other, fainter galaxy.'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.78, y: 0.67
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Identify Artifacts'
      content: [
        'Science can be messy.  We also need your help to identify image artifacts. For example, this image contains a bright star, which satures Hubble\'s instruments.'
        'Choose "cross" from the object list to mark it.'
      ]
      attach: x: 'right', to: '[value="cross"]', at: x: 'left'
      style: width: 460
      nextOn: click: '.species [value="cross"]'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="cross"]), .species .finished .other-creatures'

    new Step
      heading: 'Identify Artifacts'
      content: [
        'To mark the cross, click and drag from end-to-end along each of the two crossing line segments.'
        'When you can only see one spike, you should use the \'linear\' tool instead.'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.7, y: 0.15
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Black and white images'
      content: [
        'You can also click here to see images in just one channel.'
        'Sometimes this helps you see fainter objects more easily.'
      ]
      attach: y: 'top', to: '#toggleCol', at: y: 2
      onEnter: ->
        jQuery("#classifier .selection-area img").attr("src", "http://www.andromedaproject.org/subjects/standard/tutorial_bw.jpeg")
      style: width: 400
      continueText: 'Next'
      arrowClass: 'up-center'

    new Step
      heading: 'Done Identifying and Marking'
      content: [
        'Now that we\'ve finished marking all objects, click "Finished"'
      ]
      attach: x: 'right', to: '.species .finished', at: x: -0.05
      style: width: 390
      nextOn: click: '.species .finished'
      arrowClass: 'right-middle'

    new Step
      heading: 'Chip-gaps'
      content: [
        'You may sometimes see blocky image artifacts like this.'
        'These are called chip-gaps and you don\'t need to mark them.'
      ]
      attach: to: '.creature-picker', at: x: 0.3, y: 0.22
      onEnter: ->
        jQuery("#classifier .selection-area svg").empty()
        jQuery("#classifier .selection-area img").attr("src", "http://www.andromedaproject.org/subjects/standard/tutorial_chipgap.jpeg")
      style: width: 400
      continueText: 'Next'

    new Step
      heading: 'The End: Great job!'
      content: [
        'Finally, you can use Talk to discuss images with other volunteers if you have questions or find something interesting.'
        'This concludes the tutorial. You can always consult the "Guide" page for more detailed information.'
        'Click Yes or No (bottom right) to proceed'
      ]
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      style: width: 400
      arrowClass: 'right-to'
      nextOn: click: '.talk button'
  ]
