define([
	'../array/last'
], (last)->

	class Graphic
		constructor: ->
			@be = 'graphic'
			times = last(arguments)
			@times = times or 100
			@
)