define([
	'jquery'
	'util'
	'error'
	'object/toString'
], ($, U, err, toString)->

	valids = 
		'string': -> $.isString.apply(null, arguments)
		'function': -> $.isFunction.apply(null, arguments)
		'number': -> $.isNumeric.apply(null, arguments)
		'emptyObject': -> $.isEmptyObject.apply(null, arguments)
		'plainObject': -> $.isPlainObject.apply(null, arguments)
		'window': -> $.isWindow.apply(null, arguments)
		'array': -> $.isArray.apply(null, arguments)
		'object': (obj)->  toString.call(null, obj) is '[object Object]'
		'undefined': (param)-> typeof param is 'undefined'
		'arrayLike': (arrLike)-> $.isArrayLike.apply(null, arguments)
	Type = (types, args)->
		if valids['undefined'](args)
			$.type.apply(null, arguments)
		else
			res = true
			if(valids.string(types)) types = types.match(/\S+/)
			if(valids.array(types))
				for type, i in types
					if(not valids.string(type))
						err('Unrecognized Type', type)
						res = false
						break
					else if not valids[type]
						if args[i]['be'] is type
							continue
						else
							res = false
							break
					else if(not valids[type](args[i]))
						res = false
						break
			else
				err('Unrecognized Type', types)
				res = false
			res
)	