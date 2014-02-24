define([
	'./data'
	'../promise/type'
	'../array/str2arr'
], (data, type, str2arr)->

	extend = (cCss, funcs)->
		cCss = str2arr(cCss)
		_id = cCss.join('0')
		funcs._id = _id
		for css in cCss
			data[css] = funcs
)