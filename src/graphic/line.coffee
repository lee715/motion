define([
	'./graphic'
], (G)->

	class Line extends G
		constructor: (a, b)->
			super
			@a = +a or 0
			@b = +b or 0
			@
		_getY: (x)->
			@a * x + @b
		_getS: (x)->
			@a * x * x / 2 + @b * x
)