define([
	'./graphic'
	'../util/util'
], (G, U)->

	class Parabola extends G
		constructor: (a, b)->
			super
			@a = +a or 0
			@b = +b or 0
			@
		_getY: (x)->
			@a * U.power(x, 2) + @b
		_getS: (x)->
			@a * U.power(x, 3) / 3 + @b * x
)