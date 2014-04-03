define([
	'../graphic/factory'
	'../track/mix'
], (F, M)->

	F.class(
		'fallball', 
		(t, times, decay)->
			@t = @_t = t
			@times = times
			@decay = decay or 0.9
			@a = -10
			@b = @_b = 10 * t * times
			@reverse = false
			@isEnded = false
			@
		,
		{
			endType: 'upspring'
			upspring: ->
				dc = @decay
				if @reverse
					@b *= dc
					@t *= dc
					if(@t < 0.01) then @isEnded = true
				@reverse = not @reverse
			getX: (x)->
				if @reverse then x = @t - x
				x *= @times
				x
			fix: (times)->
				unless times then return 
				stage = times % 2
				times = Math.ceil(times/2)
				unless stage
					dc = util.power(@decay, times)
					@b = @_b * dc
					@t = @_t * dc
					if @t < 0.01 then @isEnded = true
				@reverse = !!stage	
		},
		'line'
	)
)