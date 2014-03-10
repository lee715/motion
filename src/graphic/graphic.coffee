define([
	'../array/last'
], (last)->

	class Graphic
		constructor: ->
			@be = 'graphic'
			times = last(arguments)
			@times = times or 100
			@
		getX: (t)->
			x = @times * t
			x
		getY: (t)->
			@_getY(@getX(t))
		getS: (t)->
			@_getS(@getX(t))
)