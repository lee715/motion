define([
	'./graphic'
], (G)->

	class Line extends G
		constructor: (a, b)->
			super
			@a = +a or 0
			@b = +b or 0
			@
		getY: (x)->
			x = x * @times
			@a * x + @b
		getS: (x)->
			x = x * @times
			@a * x * x / 2 + @b * x
)