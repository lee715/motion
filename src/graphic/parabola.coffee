define([
	'graphic'
	'util'
], (G, U)->

	class Parabola extends G
		constructor: (a, b)->
			super
			@a = a
			@b = b
			@
		getY: (x)->
			@a * U.power(x, 2) + @b
		getS: (x)->
			@a * U.power(x, 3) / 3 + @b * x
)