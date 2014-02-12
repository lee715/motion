define([
	'graphic'
	'util'
], (G, U)->

	class Line extends G
		constructor: (a, b)->
			super
			@a = a
			@b = b
			@
		getY: (x)->
			@a * x + @b
		getS: (x)->
			@a * x * x / 2 + @b * x
)