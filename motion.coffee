require([
	'jquery'
	'util'
	'cssHandler'
	'track'
], ($, U, C, T)->

	getTrack = (track, opts)->
		if(typeof track is 'string')
			# todo
		else if($.isArray(track))
			if( $.isArray(track[0]) )
				ctor = T.mix(track, opts)
				track = new ctor(opts)
			else
				opts = $.extend({},opts, track[1])
				ctor = T.map.get(track[0])
				track = new ctor(opts)
		return track

	## motion
	$.fn.motion = (css, track, callback, opts)->
		opts = opts or {}
		# get track
		track = getTrack(track, opts)

		$(this).each((ind, dom)->
			# get step
			if($.isFunction(css))
				step = css
			else
				handler = C.handle(css, $(dom))
				step = handler.step

			t = 0
			timer = setInterval(->
				p = track.getSp(t)
				if(t and not track.getY(t) and track.opts.type is 'stop')
					clearInterval(timer)
					$(dom).animating = false
					return callback()
				step(p, track, t)
				opts.step?(p)
				t = U.beAccuracy(t + 0.04, 2)
			, 40)
		)

	$.fn.move = (track, callback, opts)->
		opts = opts or {}
		# get track
		track = getTrack(track, opts)

		$(this).each((ind, dom)->
			o = $(dom).offset()
			step = (x, y)->
				$(dom).css(
					left: o.left + x + 'px'
					top: o.top + y + 'px'
				)
			stop = opts.stop
			t = 0
			timer = setInterval(->
				x = track.getX(t)
				y = track.getY(t)
				if(stop(x, y, t))
					clearInterval(timer)
					$(dom).animating = false
					return callback()
				step(x, y, track)
				opts.step?(x, y, track)
				t = U.beAccuracy(t + 0.04, 2)
			, 40)
		)
)
