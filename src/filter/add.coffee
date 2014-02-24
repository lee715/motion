define([
	'../promise/type'
], (type)->
		add = (offset)->
			unless type('array', offset) then offset = [offset]
			@translate(offset)
			@
)