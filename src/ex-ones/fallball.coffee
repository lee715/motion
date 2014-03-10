define([
	'../graphic/factory'
	'../track/mix'
], (F, M)->

	F.class(
		'fallball', 
		(t, times, decay)->
			@t = t
			@times = times
			@decay = decay or 0.9
			@a = -10
			@b = 10 * t * times
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
		},
		'line'
	)
)