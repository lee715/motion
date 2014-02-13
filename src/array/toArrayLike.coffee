define([
	'array/push'
	'promise/type'
], (push, type)->
		(arr, affect)->
			if type('array', arr)
				res = affect or {}
				push.apply(res, arr)
				res
			else
				arr
)