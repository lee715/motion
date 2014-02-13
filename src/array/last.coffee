define(
	->
		last = (arr)->
			len = arr and arr.length
			unless len then return null
			arr[len-1]
)