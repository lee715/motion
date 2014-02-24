define([
	'../array/str2arr'
], (str2arr)->
	# 将targ中的方法复制到orig中，并使context为targ
	copy = (orig, targ, funcs)->
		if funcs
			funcs = str2arr(funcs)
			for func in funcs
				orig[func] = (
					(func)->
						->
							targ[func].apply(targ, arguments)
				)(func)
		else
			for name, func of targ
				orig[name] = (
					(func)->
						->
							func.apply(targ, arguments)
				)(func)
)