require([
	'jquery'
	'Utilities'
], ($, U)->

	class Basic
		_nameMap: {}
		_handlerMap: {}
		# 判断一个css是否是自定义css
		isCustom: (name)->
			name in @_nameMap
		getHandler: (name)->
			@_handlerMap[ @_nameMap[name] ]
		# 获取自定义css值
		_getC: (dom, name)->
			handler = @getHandler(name)
			handler.get(dom, name)
		# 设置自定义css值
		_setC: (dom, name, value)->
			handler = @getHandler(name)
			if handler.related
				@Queue.push(dom, name, value, handler, @_nameMap[name])
			else
				data = {}
				data[name] = value
				handler.set(data, dom)
		# this function is used for getting compatible css
		gcc: (prop)->
			sty = div.style
			if prop in sty then return prop
			prefixes = ['Moz', 'Webkit', 'O', 'ms']
			_prop = U.firstLetterUpper(prop)
			for prefix in prefixes
				vendor = prefix+_prop
				if(vendor in sty) return vendor
			false
		extend: (cCss, funcs)->
			if $.isArray(cCss)
				arr = cCss
			else if $.isObject(cCss)
				arr = []
				arr.push(name) for name of cCss
			else
				arr = [cCss]
			realName = arr.join('0')
			for a in arr
				@_nameMap[a] = realName
			@_handlerMap[realName] = funcs
			@

	class Handler
		constructor: (css, dom, opts)->
			@$dom = $dom = $(dom)
			@initOriginCss(css)
			@_css = css
			@
		# init original css values
		initOriginCss: (css)->
			$d = @$dom, C = Css
			@_o = {}
			step = (cssName)->
				# 源生css
				if(cc = C.gcc(cssName))
					@_o[cssName] = $d.css(cc)
				else if(C.isCustom(cssName))
					@_o[cssName] = C.get($d, cssName)
				# else 
				# 	TODO: js处理 
				# 自定义css
			if($.isArray(css))
				for va in css
					step(va)
			else if($.isObject(css))
				for va of css
					step(va)
			else
				@onError('type error in initOriginCss')
		set: ->

	div = document.createElement('div')

	Css = {
		_nameMap: {}
		_handlerMap: {}
		
		handle: (css, dom, opts)->
			return new Handler(css, dom, opts)
		
		
		
		
		
		
		}
	}

	


)