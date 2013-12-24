require([
	'jquery'
	'util'
], ($, U)->

	class Image
		constructor: (opts)->
			@opts = opts = opts or {}
			@_i = opts.interval or [0, Infinity]
			@_offX = @_i[0]
			@_t = @_i[1]
			@_r = opts.reverse
			@opts.type = @opts.type or 'stop'
		# find the last track in mix tracks
		getLast: ->
			if(@insArr)
				ins = @insArr[@insArr.length-1]
			else
				ins = @
			return ins
		isOnEnd: (x)->
			return @_t and x > @_t
		_checkT: (x, method)->
			if(this.isOnEnd(x))
				return @_check(x, method)
			else
				return false
		_check: (x, method)->
			switch @opts.type
				when 'stay'
					return @[method](@_t)
				when 'circle', 'circle-last'
					cT = x - @_t
					ins = @getLast()
					cT = cT % ins._t
					return @[method](cT)
				when 'circle-all'
					cT = U.beAccuracy( x % @_t, 2 )
					return @[method](cT)
				when 'decay', 'decay-last'
					p = @opts.data?.decay or 2
					x = x - @_t
					ins = @getLast()
					cT = x % ins._t
					times = parseInt( x / ins._t )
					if times > (@decay_times or 0)
						@a = U.beAccuracy( @a / p, 2 )
						@decay_times = times
					return @[method](cT)
				when 'decay-all'
					p = @opts.data?.decay or 2
					ins = @
					cT = x % ins._t
					times = parseInt( x / ins._t )
					if times > (@decay_times or 0)
						@a = U.beAccuracy( @a / p, 2 )
						@decay_times = times
					return @[method](cT)
				when 'decay-t'
					p = @opts.data?.decay or 1.2
					cT = x % @_t
					times = parseInt( x / @_t )
					@_decay = U.power( 0.8, times )
					return @[method](cT)
				else
					return 0
		getY: (x)->
			res = @_checkT(x, 'getY')
			if( res isnt false )
				return res
			else
				return if @_r then @_getYR(x) else @_getY(x)
		getBaseLine: (type)->
			type = type.toUpperCase()
			name = 'baseline'+type
			isDecay = /decay/.test(@opts.type)
			if(@[name])
				return if isDecay then U.power(2, @decay_times or 0) * @[name] else @[name]
			if(@opts[name])
				@[name] = @opts[name]
				return if isDecay then U.power(2, @decay_times or 0) * @[name] else @[name]
			else
				# case mixin 
				if @insArr
					res = []
					for ins in @insArr
						res.push( ins.getBaseLine(type) )
					@[name] = Math.max.apply(Math, res)
				# normal case
				else
					@[name] = @['get'+type](@_t)
			return @[name]
		getYp: (x)->
			s = @getY(x)
			_endY = @getBaseLine('Y')
			res = s / _endY
			if(@_decay)
				res = U.beAccuracy( res * @_decay )
			return res
		getS: (x)->
			res = @_checkT(x, 'getS')
			if( res isnt false )
				return res
			else
				return if @_r then @_getSR(x) else @_getS(x)
		getSp: (x)->
			s = @getS(x)
			_endS = @getBaseLine('S')
			res = s / _endS
			if(@_decay)
				res = U.beAccuracy( res * @_decay )
			return res
		_getYR: (x)->
			if(@_t is Infinity) then 0 else @_getY(@_t - x)
		_getSR: (x)->
			@_getS(@_t) - @_getS(@_t - x)

	# 抛物线
	class Parabola extends Image
		constructor: (opts)->
			super
			@a = opts.a
			@b = opts.b
			@
		_getY: (x)->
			x += @_offX
			return @a * U.power(x, 2) + @b
		_getS: (x)->
			x += @_offX
			@a * U.power(x, 3) / 3 + @b * x

	# Log e： a * log p X + b
	class Log extends Image
		constructor: (opts)->
			super
			@a = opts.a
			@b = opts.b
			@p = opts.p
			@
		_getY: (x)->
			return @a * Math.log(x) / Math.log(@p) + @b
		_getS: (x)->
			return 0

	class Lg extends Log
		constructor: (opts)->
			super
			@p = 10
			@
	#直线
	class Line extends Image
		constructor: (opts)->
			super
			@a = opts.a
			@b = opts.b
			@
		_getY: (x)->
			x += @_offX
			return @a * x + @b
		_getS: (x)->
			x += @_offX
			@a * x * x / 2 + @b * x

	class Mixin extends Image
		_getPos: (x)->
			arr = @tArr
			i = arr.length
			res = 0
			while i--
				if(x > arr[i])
					res = i+1
					break
			return res
		getY: (x)->
			res = @_checkT(x, 'getY')
			if( res isnt false )
				return res
			else
				pos = @_getPos(x)
				ts = @tArr
				iss = @insArr
				x -= ts[ pos - 1 ] or 0
				res = iss[ pos ].getY(x)
				return res
		getS: (x)->
			res = @_checkT(x, 'getS')
			if( res isnt false )
				return res
			else
				pos = @_getPos(x)
				sArr = @_getSArr()
				res = sArr[ pos - 1 ] or 0
				x -= @tArr[ pos - 1 ] or 0
				res += @insArr[pos].getS(x)
				return res
		_getSArr: ->
			if(@sArr) then return @sArr
			ts = @tArr
			iss = @insArr
			ss = []
			for t, i in ts
				ss.push(iss[i].getS( ts[i] - (ts[i-1] or 0 ) ))
			ss = U.getSumArr(ss)
			@sArr = ss
			ss

	T = Track = {
		
		# 混合方法用于将不同的轨迹拼接起来，自定义轨迹
		# params
		# 	arr : {Array}  需要拼接的轨迹的数组
		# 	opts : {Object}
		# example
		# 	mix([['line', {a:1,b:0}],['parabola', {a:1,b:0}]],opts)
		# 	=>
		# 		直线与抛物线的拼接轨迹
		mix: (arr, opts)->
			insArr = []
			map = @map
			$.each(arr, (index, item)->
				name = item[0]
				options = item[1]
				Ctor = map.get(name)
				Ctor and insArr.push(new Ctor(options))
			)
			# if opts.type is 'stay'
			# 	stayIns = new Line({a: 0})
			# else
			# 	stayIns = new Line({a: 0, b: 0})
			# insArr.push(stayIns)
			class X extends Mixin
				constructor: (opts, tArr)->
					super
					@insArr = insArr = @_insArr.slice()
					if(tArr)
						@tArr = tArr
						for ins, i in insArr
							ins._t = @tArr[i]
					else
						@tArr = []
						for ins in insArr
							@tArr.push(ins._t)
					@_t = U.getSum(@tArr)
					@tArr = U.getSumArr( @tArr )
					@
				_insArr: insArr
			X
		# 将轨迹的索引加入map中
		push: ->
			@map.set.apply(@map, arguments)
		# 该方法用于扩展轨迹类
		# 扩展类均在Custom命名空间下
		extend: ->
			args = arguments
			if $.isArray(args[1])
				@_extendMixin.apply(@, args)
			else
				@_extendBasic.apply(@, args)
		# 扩展混合轨迹类
		# params
		#   name: {String}  类名
		#   arr: {Array} 混合的基础类
		#   opts: {Object} 
		# example
		# 	_extendMixin('nv', [
		# 			['line', {a:0, b:0}]
		# 			['parabola',{a:1, b:2}]
		# 		], {stay: false})
		# 	=>
		# 	一条直线加抛物线的组合轨迹  
		_extendMixin: (name, arr, opts)->
			@push(name, @mix(opts, arr))
		# 扩展基础轨迹类
		# params
		# 	name: {String}  类名
		# 	ctor: {Function} 构造函数
		# 	statics: {Object} 原型方法集,通常statics中需要包含_getS或_getY方法
		_extendBasic: (name, ctor, statics, parent)->
			# Funcs = $.extend({constructor: ctor}, statics)
			if(parent)
				parent = parent.toLowerCase()
				Pnt = @map.get(parent)
			else
				Pnt = Image
			class X extends Pnt
				constructor: ctor
			$.extend(X.__super__, statics)
			@push(name, X)
	}

	Track.map = new U.Map(
		root: Track
	)

	# 将内置的轨迹函数加入map中
	Track.push(
		'line': Line
		'parabola': Parabola
		'log': Log
		'lg': Lg
	, 'Math')

	return Track
)