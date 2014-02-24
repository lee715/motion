define(
	->
		insert = (arr, data, index)->
			index = index or 0
			if index
				prev = arr.slice(0, index)
				next = arr.slice(index)
				arr = prev.concat(data, next)
			else
				arr.unshift(data)
)