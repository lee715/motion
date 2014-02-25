define([
	'../util/util'
], (U)->
		# this function is used for getting compatible css
		gcc = (prop)->
			div = document.createElement('div')
			sty = div.style
			if sty[prop] isnt undefined then return prop
			prefixes = ['Moz', 'webkit', 'O', 'ms']
			_prop = U.firstLetterUpper(prop)
			for prefix in prefixes
				vendor = prefix+_prop
				if sty[vendor] isnt undefined then return vendor
			false
)