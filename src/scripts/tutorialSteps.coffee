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
        'Star clusters show up more clearly in the blue band of the optical spectrum.'
        'In this image we can see two clusters.'
        'We\'ll mark these first.'
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
      attach: x: 'left', to: '.creature-picker', at: x: 0.2, y: 0.37
      style: width: 400
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'left-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Mark Star Clusters'
      content: [
        'Now let\'s mark another cluster.'
      ]
      attach: x: 'left', to: '.creature-picker', at: x: 0.5, y: 0.97
      style: width: 240
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Identifying Background Galaxies'
      content: [
        'We\'ve finished marking all the clusters in this image. On to the background galaxies!'
        'Background galaxies are more distant galaxies that we occasionally see through all the dust of a foreground galaxy.'
        'Choose "galaxy" from the species list to mark them.'
      ]
      attach: x: 'right', to: '[value="galaxy"]', at: x: 'left'
      style: width: 460
      nextOn: click: '.species [value="galaxy"]'
      arrowClass: 'right-middle'
      block: '.species .toggles button:not([value="galaxy"]), .species .finished .other-creatures'

    new Step
      heading: 'Marking'
      content: [
        'Mark the galaxy by clicking in the center then dragging out until the majority is enclosed (just like the star clusters).'
      ]
      style: width: 320
      attach: x: 'right', to: '.creature-picker', at: x: 0.67, y: 0.55
      nextOn: 'create-marking': '#classifier'
      arrowClass: 'right-middle'
      block: '.species .finished .other-creatures'

    new Step
      heading: 'Artifacts'
      content: [
        'Science can be messy.  We also need your help to identify telescope artifacts.'
      ]
      attach: x: 'right', to: '.creature-picker', at: x: 0.67, y: 0.55
      style: width: 320
      continueText: 'Okay!'
      block: '.species .toggles .species .finished'

    new Step
      heading: 'Chip Gap'
      content: [
        'This image has a chip gap that comes from the Advanced Camera for Surveys, an instrument on the Hubble Space Telescope.'
        'You can see a long diagonal line that goes across the image.'
      ]
      attach: x: 'right', to: '#artefact-list [value="linear"]', at: x: 'left'
      style: width: 490
      arrowClass: 'right-middle'
      nextOn: click: '#artefact-list [value="linear"]'
      block: '.species .toggles .species .finished #artefact-list button:not([value="linear"])'

    new Step
      heading: 'Chip Gap'
      content: [
        'Click and drag from the the top to the bottom of the gap'
      ]
      attach: x: 'right', to: '.creature-picker', at: x: 0.30, y: 0.50
      style: width: 390
      arrowClass: 'right-middle'
      nextOn: 'create-half-axes-marker': '#classifier'
      block: '.species .toggles .species .finished #artefact-list'
    
    new Step
      heading: 'Chip Gap'
      content: [
        'Click and drag along the width of the artifact.'
      ]
      attach: x: 'right', to: '.creature-picker', at: x: 0.30, y: 0.50
      style: width: 390
      arrowClass: 'right-middle'
      nextOn: 'create-axes-marker': '#classifier'
      block: '.species .toggles .species .finished #artefact-list'

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
      heading: 'Great job!'
      content: [
        'You can use Talk to discuss images with other volunteers if you have questions or find something interesting.'
        'This concludes the tutorial. Now you\'re ready to explore and complete some classifications on your own!'
        'If you\'re ever unsure of what to mark, you can always consult the guide on the "About" page for descriptions of the star clusters, background galaxies and artifacts. You can then return to the "Classify" page when you\'re ready.'
      ]
      attach: to: '.creature-picker', at: x: 0.5, y: 0.5
      style: width: 400
      arrowClass: 'right-to'
      nextOn: click: '.talk button'
  ]
