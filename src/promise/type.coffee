define([
	'../object/toString'
	'../array/toArray'
	'../array/last'
	'../array/str2arr'
	'../function/returnTrue'
	'../function/returnFalse'
], (toString, toArray, last, str2arr, returnTrue, returnFalse)->

	valids = 
		'string': (str)-> typeof str is 'string' 
		'function': -> $.isFunction.apply(null, arguments)
		'number': -> $.isNumeric.apply(null, arguments)
		'emptyObject': -> $.isEmptyObject.apply(null, arguments)
		'plainObject': -> $.isPlainObject.apply(null, arguments)
		'window': -> $.isWindow.apply(null, arguments)
		'array': -> $.isArray.apply(null, arguments)
		'object': (obj)->  toString.call(obj) is '[object Object]'
		'undefined': (param)-> typeof param is 'undefined'
		'arrayLike': (arrLike)-> isArrayLike(arrLike)
	isArrayLike = (obj)->
		len = obj.length
		type = $.type(obj)
		if(type is 'function' or $.isWindow(obj)) then return false
		if obj.nodeType is 1 and len then return true
		return type is 'array' or len is 0 or typeof len is 'number' and len > 0 and (len-1) in obj
	check = (type, args)->
		if not valids[type]
			if args['be'] is type
				true
			else
				false
		else if(not valids[type](args))
			false
		else
			true
	Type = (types, args, callback)->
		if valids['undefined'](args)
			$.type.apply(null, arguments)
		else
			res = true
			types = str2arr(types)
			if types.length is 1 then args = [args]
			if(types.length)
				for type, i in types
					unless check(type, args[i]) then return res = false
			else
				err('Unrecognized Type', types)
				res = false
			if res and callback
				callback.apply(null, args)
			else
				res
)	