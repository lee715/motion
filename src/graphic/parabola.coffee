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
		getY: (x)->
			x = x * @times
			@a * U.power(x, 2) + @b
		getS: (x)->
			x = x * @times
			@a * U.power(x, 3) / 3 + @b * x
)