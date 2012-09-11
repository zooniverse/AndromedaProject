
Styles =
  
  label:
    text:
      fill: '#fff'
      font: 'bold 11px "Open Sans", sans-serif'
      'text-anchor': 'start'
      cursor: 'default'

    deleteButton:
      stroke: 'none'
      'stroke-width': 0
      cursor: 'pointer'

      text:
        fill: '#fff'
        font: 'bold 12px "Open Sans", sans-serif'
        'text-anchor': 'start'
        cursor: 'pointer'

    rect:
      stroke: 'none'
      'stroke-width': 0

  circle:
    cursor: 'move'
    fill: '#fff'
    r: 5
    stroke: 'none'
    'stroke-width': 0

    hover:
      r: 7

  crossCircle:
    cursor: 'move'
    fill: '#fff'
    r: 7
    stroke: '#fff'
    'stroke-width': 2

  line:
    stroke: '#fff'
    'stroke-width': 2

  boundingBox:
    opacity: 0.5
    stroke: '#fff'
    'stroke-dasharray': '- '
    'stroke-linejoin': 'round'
    'stroke-width': 2

  button:
    fill: '#000'
    stroke: '#fff'
    'stroke-width': 2

  fish: '#0BC7E8'

  scallop: '#FD6500'

  crustacean: '#B9CA00'

  seastar: '#C512E0'

  cool: '#001E29'

  helperCircle:
    opacity: 0.5
    r: 3
    stroke: 'none'
    'stroke-width': 0

    active:
      opacity: 1
      r: 5

module.exports = Styles