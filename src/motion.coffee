define([
	'./track/track'
	'./promise/type'
	'./css/handler'
], (Track, type, Css)->

	$.fn.motion = (css, track, opts)->
		motion([css, @], track, opts)
	motion = (step, track, opts)->
		unless type('function', step)
			step.push(opts)
			step = Css.apply(Css, step)
		if step
			ctl = Track.get(track, opts).promise()
			ctl.on('progress', step)
				.on('done', ->
					console.log('is done now')
				)
			ctl
	return motion
)