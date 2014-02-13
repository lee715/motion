define([
	'array/toArray'
	'array/last'
	'function/returnTrue'
	'function/returnFalse'
	'promise/type'
], (toArray, last, returnTrue, returnFalse, type)->
		promise = ->
			args = toArray( arguments )
			if type('function', last(args))
				callback = args.pop()
			if type.apply(null, args)
				(callback or returnTrue)()
			else
				returnFalse()
)	