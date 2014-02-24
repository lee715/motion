define([
	'./slice'
	'../promise/promise'
], (slice, promise)->
		->
			promise('array number', arguments, (arr, len)->
				l = arr.length
				if l < len
					c = len - l
					while c--
						arr.push(0)
				else
					arr = arr.slice(0, len)
				arr
			)
)