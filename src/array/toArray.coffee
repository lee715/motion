define([
	'array/slice'
], (slice)->
		(arrayLike)->
			args = slice.call(arguments, 1)
			slice.apply( arrayLike, args )
)