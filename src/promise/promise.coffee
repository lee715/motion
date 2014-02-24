define([
	'../array/toArray'
	'../array/last'
	'../function/returnTrue'
	'../function/returnFalse'
	'./type'
], (toArray, last, returnTrue, returnFalse, type)->
		promise = ->
			args = toArray( arguments )
			if type('function', last(args))
				callback = args.pop()
			if type.apply(null, args)
				(callback or returnTrue).apply(null, args[1])
			else
				returnFalse()
)	