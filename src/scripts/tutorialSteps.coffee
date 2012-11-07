define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      heading: 'Welcome to the Andromeda Project!'
      content: [
        'This short tutorial will guide you through the classification process.'
        'Please read each step carefully and follow the instructions.'
      ]
      continueText: 'Begin'
      style: width: 450
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      block: '.options'

    new Step
      heading: 'Identify Star Clusters'
      content: [
        'Let\'s identify star clusters in the image.'
        'Star clusters are compact groups of many stars.'
        'Star clusters usually appear quite blue, but some clusters may appear orange if they are old or dusty.'
        'In this image we can see two clusters. We\'ll mark these first.'
      ]
      continueText: 'Next'
      style: width: 450
      attach: to: '.creature-picker'
      block: '.options'
    
    new Step
      heading: 'Identify Star Clusters'
      content: [
        'The button "star cluster" is always marked by default.'
      ]
      attach: x: 'right', to: '[value="cluster"]', at: x: 'left'
      style: width: 340
      continueText: 'Next'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="cluster"]), .species .finished .other-creatures'
      
    new Step
      heading: 'Mark Star Clusters'
      content: [
        'Mark the cluster by clicking in the center then dragging out until the majority of the cluster is enclosed.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 0.3, y: 0.66
      style: width: 400
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Mark Star Clusters'
      content: [
        'Now let\'s mark the other, fainter cluster.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 0.25, y: 0.2
      style: width: 240
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Identifying Background Galaxies'
      content: [
        'We\'ve finished marking all the clusters in this image. On to the background galaxies!'
        'Background galaxies are distant objects that shine through the disk of Andromeda.'
        'These galaxies appear fuzzy and vary in size.'
        'Choose "galaxy" from the species list to mark them.'
      ]
      attach: x: 'right', to: '[value="galaxy"]', at: x: 'left'
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
      attach: x: 'left', to: '.creature-picker', at: x: 0.4, y: 0.6
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'
      
    new Step
      heading: 'Mark Background Galaxies'
      content: [
        'Now let\'s mark the other, fainter galaxy.'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.75, y: 0.65
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Identify Artifacts'
      content: [
        'Science can be messy.  We also need your help to identify telescope artifacts.'
        'This image has a saturated star.'
        'The cross-shaped pattern centered on the star is caused by the support structure of Hubble’s secondary mirror.'
      ]
      attach: x: 'right', to: '.creature-picker', at: x: 0.75, y: 0.55
      style: width: 320
      continueText: 'Okay!'
      block: '.species .toggles .species .finished'

    new Step
      heading: 'Identify Artifacts'
      content: [
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
        'To mark the cross, click and drag from end-to-end along the two crossing line segments.'
        'When you can only see one spike, you can use the \'linear\' tool instead.'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.7, y: 0.15
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Black and white images'
      content: [
        'Sometimes we\'ll show you grayscale images such as this one.'
        'These are just images taken with only one of the camera\'s filters.'
        'You just mark them as you do with the colour images.'
      ]
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      onEnter: ->
        jQuery("#classifier .selection-area img").attr("src", "http://www.andromedaproject.org/subjects/standard/tutorial_bw.jpeg")
      style: width: 400
      continueText: 'Next'
      arrowClass: 'left-middle'

    new Step
      heading: 'Done Identifying and Marking'
      content: [
        'Now that we\'ve finished marking all objects, click "Finished"'
      ]
      attach: x: 'right', to: '.species .finished', at: x: 'left'
      style: width: 390
      nextOn: click: '.species .finished'
      arrowClass: 'right-middle'

    new Step
      heading: 'Chip-gaps'
      content: [
        'You may sometimes see blocky image artifacts like this.'
        'These are called chip-gaps and you don\'t need to mark them.'
      ]
      attach: to: '.creature-picker', at: x: 0.25, y: 0.5
      onEnter: ->
        jQuery("#classifier .selection-area svg").empty()
        jQuery("#classifier .selection-area img").attr("src", "http://www.andromedaproject.org/subjects/standard/tutorial_chipgap.jpeg")
      style: width: 400
      continueText: 'Next'
      arrowClass: 'right-middle'

    new Step
      heading: 'The End: Great job!'
      content: [
        'You can use Talk to discuss images with other volunteers if you have questions or find something interesting.'
        'This concludes the tutorial. Now you\'re ready to explore on your own! If you\'re ever unsure of what to mark, you can always consult the "Guide" page.'
        'Click Yes or No (bottom right) to proceed'
      ]
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      style: width: 400
      arrowClass: 'right-to'
      nextOn: click: '.talk button'
  ]
