define([
	'../util/util'
	'./data'
	'./gcc'
	'./custom'
	'../promise/type'
	'../error'
], (U, data, gcc, C, type, err)->

	class Handler
		constructor: (css, dom, opts)->
			@opts = opts || {}
			@$dom = $dom = $(dom)
			@initOriginCss(css)
			@_css = css
			@queue = new U.Queue()
			@initStep()
			@
		# init original css values
		initOriginCss: (css)->
			$d = @$dom
			@_o = {}
				
			if(type('array', css))
				for va in css
					@_o[va] = @get(va)
			else if(type('object', css))
				for va of css
					@_o[va] = @get(va)
			else
				err('type error in initOriginCss')
		# init step function
		initStep: ->
			isStep = @opts.endType is 'step'
			endC = @_css
			startC = @_o
			@step = (p)=>
				_cur = {}
				for key,val of endC
					if(isStep)
						_cur[key] = val 
					else
						_cur[key] = U.awu('-', val ,startC[key])
					_cur[key] = U.awu('*', _cur[key], p)
					_cur[key] = U.awu('+', _cur[key], startC[key])
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
			if(cc = gcc(name))
				return @$dom.css.apply(@$dom, args)
			# 自定义css
			else if(C.isCustom(name))
				args.unshift(@$dom)
				args.push(@queue)
				return C[method].apply(C, args)
			else
				# js处理
				return 
	return (css, dom, opts)->
			handlers = []
			dom.each((ind, d)->
				handlers.push(new Handler(css[ind] or css, d, opts))
			)
			step = (p)->
				for handler in handlers
					handler.step(p)
			step
)