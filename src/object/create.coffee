define([
	'../promise/type'
], (type)->
	if type('undefined', Object.create)
		Object.create = (o)->
			F = ->
			F.prototype = o
			new F
	Object.create
)