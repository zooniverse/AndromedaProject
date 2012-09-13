define (require, exports, module) ->
  Spine = require 'Spine'
  L     = require('Leaflet')
  
  class Sky extends Spine.Controller
    
    mapOptions:
      attributionControl: false
      worldCopyJump: false
      
    constructor: ->
      super
      @createMap()
    
    createMap: =>
      map = L.map('banner', @mapOptions).setView([-35, 40], 3)
      console.log map.getBounds().getCenter()
      layer = L.tileLayer('/tiles/#{tilename}.jpg',
        minZoom: 2
        maxZoom: 8
      )
      layer.getTileUrl = (tilePoint) ->
        
        zoom = @_getZoomForUrl()
        convertTileUrl = (x, y, s, zoom) ->
          console.log arguments
          pixels = Math.pow(2, zoom)
          d = (x + pixels) % (pixels)
          e = (y + pixels) % (pixels)
          f = "t"
          g = 0
          while g < zoom
            pixels = pixels / 2
            if e < pixels
              if d < pixels
                f += "q"
              else
                f += "r"
                d -= pixels
            else
              if d < pixels
                f += "t"
                e -= pixels
              else
                f += "s"
                d -= pixels
                e -= pixels
            g++
          x: x
          y: y
          src: f
          s: s

        url = convertTileUrl(tilePoint.x, tilePoint.y, 1, zoom)
        return "/tiles/#{url.src}.jpg"

      layer.addTo map
  
  module.exports = Sky