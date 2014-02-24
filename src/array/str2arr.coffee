define([
	'../regex/rnotwhite'
], (rnw)->
		str2arr = (str)->
			if(typeof str is 'string')
				str.match(rnw)
			else if(str instanceof Array)
				str
			else
				[]
)	