define([
	'jquery'
	'util'
], ($, U)->

	class Basic
		_map: {}
		# 判断一个css是否是自定义css
		isCustom: (name)->
			return !!@_map[ name ]
		getHandler: (name)->
			@_map[ name ]
		# 获取自定义css值
		_getC: (dom, name)->
			handler = @getHandler(name)
			handler.get.call(@, dom, name)
		# 设置自定义css值
		_setC: (dom, name, value)->
			handler = @getHandler(name)
			if handler.related
				id = handler._id
				(data = {})[name] = value
				@queue.push(id, (data)=>
					handler.set.call(@, dom, data)
				, data)
			else
				data = {}
				data[name] = value
				handler.set.call(@, dom, data)
		# this function is used for getting compatible css
		gcc: (prop)->
			div = document.createElement('div')
			sty = div.style
			if sty[prop] isnt undefined then return prop
			prefixes = ['Moz', 'webkit', 'O', 'ms']
			_prop = U.firstLetterUpper(prop)
			for prefix in prefixes
				vendor = prefix+_prop
				if sty[vendor] isnt undefined then return vendor
			false
		extend: (cCss, funcs)->
			if $.isArray(cCss)
				arr = cCss
			else if typeof cCss is 'object'
				arr = []
				arr.push(name) for name of cCss
			else
				arr = [cCss]
			_id = arr.join('0')
			funcs._id = _id
			for a in arr
				@_map[a] = funcs
			@

	spreader = new Basic()

	class Handler extends Basic
		constructor: (css, dom, opts)->
			@$dom = $dom = $(dom)
			@initOriginCss(css)
			@_css = css
			@queue = new U.Queue()
			@initStep()
			@
		# init original css values
		initOriginCss: (css)->
			$d = @$dom
			C = Css
			@_o = {}
				
			if($.isArray(css))
				for va in css
					@_o[va] = @get(va)
			else if(typeof css is 'object')
				for va of css
					@_o[va] = @get(va)
			else
				@onError('type error in initOriginCss')
		# init step function
		initStep: ->
			endC = @_css
			startC = @_o
			@step = (p)=>
				_cur = {}
				for va of endC
					_cur[va] = U.awu('-', endC[va] ,startC[va])
					_cur[va] = U.awu('*', _cur[va], p)
					_cur[va] = U.awu('+', _cur[va], startC[va])
				@set(_cur)
		get: (name)->
			return @_attr('get', name)
		set: (css)->
			for key, value of css
				@_attr('set', key, value)
			@queue.next()
		_attr: (method, name, value)->
			args = [].slice.call(arguments, 1)
			# 源生css
			if(cc = @gcc(name))
				return @$dom.css.apply(@$dom, args)
			# 自定义css
			else if(@isCustom(name))
				args.unshift(@$dom)
				return @['_'+method+'C'].apply(@, args)
			else
				# js处理
				return 

	Css = {
		handle: (css, dom, opts)->
			return new Handler(css, dom, opts)
		spreadCss: (cCss, funcs)->
			return spreader.extend(cCss, funcs)
	}

	return Css

)