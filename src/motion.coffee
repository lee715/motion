define([
	'./track/track'
	'./promise/type'
], (Track, type)->
	motion = (step, track, opts)->
		# unless type('function', step)
		# 	step = Css(step)
		Css = 
			step: (p)->
				console.log(p)
		if step
			ctl = Track.get(track, opts).promise()
			ctl.on('progress', step, Css)
				.on('done', ->
					)
			ctl

)