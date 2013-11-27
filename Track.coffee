require([
	'jquery'
	'Utilities'
], ($, U)->

	class Image
		constructor: (opts)->
			@_i = opts.interval or [0, Infinity]
			@_offX = @_i[0]
			@_t = @_i[1]
			@_r = opts.reverse
			@
		getY: (x)->
			if @_r then @_getYR(x) else @_getY(x)
		getS: (x)->
			if @_r then @_getSR(x) else @_getS(x)
		_getYR: (x)->
			if(@_t is Infinity) 0 else @_getY(@_t - x)
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

	# variable accelerated motion
	# opts = {
	# 	v0: 初始速度
	# 	vt: 末速度
	# 	t: 总时间(s)
  # }
  class Vam extends Parabola
  	constructor: (opts)->
  		v0 = opts.v0, vt = opts.vt, t = opts.t, s = opts.s
  		opts.a = ( vt - v0 )/( t * t )
  		opts.b = v0
  		super
  		@

  # constant acceleration motion
	# opts = {
	# 	v0: 初始速度
	# 	vt: 末速度
	# 	t: 总时间(s)
  # }
  class Cam extends Line
  	constructor: (opts)->
  		opts.a = ( opts.vt - opts.v0 ) / opts.t
  		opts.b = opts.v0
  		super
  		@

	class Mixin extends Image
		_getPos: (x)->
			arr = @tArr, i = arr.length, res = 0
			while i--
				if(x > arr[i]){
					res = i+1
					break
				}
			return res
		getY: (x)->
			pos = @_getPos(x), ts = @tArr, iss = @insArr
			x -= ts[ pos - 1 ] or 0
			res = iss[ pos ].getY(x)
			return res
		getS: (x)->
			pos = @_getPos(x), sArr = @_getSArr()
			res = sArr[ pos - 1 ] or 0
			x -= @tArr[ pos - 1 ] or 0
			res += @insArr[pos].getS(x)
			return res
		_getSArr: ->
			if(@sArr) return @sArr
			ts = @tArr, iss = @insArr, ss = []
			for t, i in ts
				ss.push(iss[i].getS( ts[i] - ts[i-1] or 0 ))
			ss = U.getSumArr(ss)
			@sArr = ss
			ss

	Track = {
		map: new U.Map(
			root: Track
		)
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
			$.each(arr, (index, item)->
				name = item[0]
				options = item[1]
				Ctor = this.map.get(name)
				Ctor and insArr.push(new Ctor(options))
			)
			if opts.stay
				stayIns = new Line({a: 0})
			else
				stayIns = new Line({a: 0, b: 0})
			insArr.push(stayIns)
			class X extends Mixin
				constructor: (tArr, opts)->
					super
					tArr.push(Infinity)
					@tArr = tArr
					@insArr = @_insArr.slice()
					for ins, i in @insArr
						ins._t = @tArr[i]
					@opts = opts or {}
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
				@_extendBasic.apply(@, args)
			else
				@_extendMixin.apply(@, args)
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
			@push(name, @mix(arr, opts))
		# 扩展基础轨迹类
		# params
		# 	name: {String}  类名
		# 	ctor: {Function} 构造函数
		# 	statics: {Object} 原型方法集,通常statics中需要包含_getS或_getY方法
		_extendBasic: (name, ctor, statics)->
			$.extend(ctor.prototype, statics)
			@push(name, ctor)
	}

	# 将内置的轨迹函数加入map中
	Track.push(
		'line': Line
		'parabola': Parabola
	, 'Math')

	Track.push(
		'vam': Vam
		'cam': Cam
	, 'Physics')
)