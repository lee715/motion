define([
	'./graphic'
], (G)->

	class Log extends G
		# Log e： a * log p X + b
		constructor: (a, b, p)->
			super
			@a = +a or 0
			@b = +b or 0
			@p = +p or 2
			@
		getY: (x)->
			x = x * @times
			@a * Math.log(x) / Math.log(@p) + @b
		getS: (x)->
			0
)