define([
	'graphic'
	'util'
], (G, U)->

	class Log extends G
		# Log e： a * log p X + b
		constructor: (a, b, p)->
			super
			@a = a
			@b = b
			@p = p
			@
		getY: (x)->
			@a * Math.log(x) / Math.log(@p) + @b
		getS: (x)->
			0
)