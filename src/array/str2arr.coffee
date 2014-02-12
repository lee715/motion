define([
	'promise/type'
	'regex/rnotwhite'
], (type, rnw)->
		str2arr = (str)->
			if(type('string', str))
				str.match(rnw)
			else if(type('array', str))
				str
			else
				false
)	