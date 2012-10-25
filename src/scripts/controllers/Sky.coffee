define (require, exports, module) ->
  Spine = require 'Spine'
  L     = require('Leaflet')
  
  class Sky extends Spine.Controller
    
    mapOptions:
      attributionControl: true
      worldCopyJump: false
      
    constructor: ->
      super
      
      jQuery(window).bind('hashchange', @createMap)
      if window.location['hash'] in ['', '#!/home']
        @createMap()
    
    createMap: =>
      return if @map?
      return unless window.location['hash'] in ['', '#!/home']
      @map = L.map('banner', @mapOptions).setView([14, 0], 2)
      @map.attributionControl.setPrefix('')
      
      layer = L.tileLayer('/tiles/#{tilename}.jpg',
        minZoom: 2
        maxZoom: 8
        attribution: 'Robert Gendler - The Andromeda Galaxy (M31) &copy; 2005'
        noWrap: true
      )
      # layer.getTileUrl = (tilePoint) ->
      #   z = @_getZoomForUrl()
      #   x = tilePoint.x
      #   y = tilePoint.y
      #   return "http://www.andromedaproject.org.s3.amazonaws.com/tiles/F475_B01/#{z}/#{x}/#{y}.png"
      
      layer.getTileUrl = (tilePoint) ->
        
        zoom = @_getZoomForUrl()
        convertTileUrl = (x, y, s, zoom) ->
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
        return "http://www.andromedaproject.org.s3.amazonaws.com/alpha/tiles/#{url.src}.jpg"

      layer.addTo @map
  
  module.exports = Sky