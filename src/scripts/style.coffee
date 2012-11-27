define (require, exports, module) ->
	module.exports =
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
			fill: '#FAFAFA'
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
			cluster:
				stroke: '#DB9F00'
				'stroke-width': 2
			galaxy:
				stroke: '#9C62EE'
				'stroke-width': 2
			ghost:
				stroke: '#097D4E'
				'stroke-width': 2
			cross:
				stroke: '#A20F32'
				'stroke-width': 2
			linear:
				stroke: '#3D75DB'
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

		cluster: '#DB9F00'
		galaxy: '#9C62EE'
		ghost: '#097d4e'
		cross: '#a20f32' 
		linear: '#3D75DB'  

		cool: '#001e29'

		helperCircle:
			opacity: 0.5
			r: 3
			stroke: 'none'
			'stroke-width': 0

			active:
				opacity: 1
				r: 5
