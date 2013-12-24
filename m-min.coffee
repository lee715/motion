## Utilities
# 默认所有数值计算结果的精度
ACCUR = 6

# Math扩展
_math = {
	isInt: (x)->
		return x is parseInt(x)
	isOdd: (x)->
		return not @isInt( x/2 )
	# 获取num的精度
	getAccuracy: (num)->
		return (num + '').split('.')[1]?.length or 0
	# 将num精度化
	beAccuracy: (num, accur)->
		accur = accur or ACCUR
		curAccur = this.getAccuracy(num)
		if curAccur <= accur
			res = num
		else
			k = this.power(10, accur)
			res = Math.round(num * k)/k
		return res
	# 乘方函数，n为阶数，可以是正负整数或0.5的倍数
	power: (x, n, accuracy)->
		res = x
		isInt = this.isInt
		bA = this.beAccuracy
		# isRec 标识结果是否需求倒
		isRec = false
		# isSqrt 标识结果是否需开方
		isSqrt = false

		if n is 0 then return 1
		if n < 0
			isRec = true
			n = Math.abs(n)
		if not isInt(n) and isInt(2*n)
			n = n * 2
			isSqrt = true
		if not isInt(2*n) then n = parseInt(n)

		while(--n > 0)
			res = res * x
		if isSqrt then res = bA(Math.sqrt(res))
		if isRec then res = bA(1 / res)
		return res
	# 由传入的正弦余弦值得到其对应的角度
	getDeg: (sin, cos)->
		bA = this.beAccuracy
		degS = Math.asin(sin) * 180 / Math.PI
		degC = Math.acos(cos) * 180 / Math.PI
		_degS = degS >= 0 ? 180 - degS : -degS - 180
		_degC = -degC
		p = parseInt
		if(p(degS) is p(degC)) or (p(degS) is p(_degC))
			res = degS
		else
			res = _degS
		return bA(res)
	# 得到单位
	getUnit: (arr)->
		unless $.isArray(arr) then arr = [arr]
		res = false
		unit = (val)-> return val
		match = false
		reg = /[\d|.]+/g
		for str in arr
			if(typeof str is 'string')
				str.replace(reg, (match)->
					match = true
					return '{num}'
				)
				if match and str.length > 5
					res = str
					break
		if res 
			unit = (num)->
				return res.replace('{num}', num)
		return unit
	withOutUnit: (arr)->
		res = []
		reg = /[a-zA-Z]+/g
		if not $.isArray(arr) then arr = [arr]
		$.each(arr, (index, item)->
			unless item 
				item = 0
			else
				item = item.replace?(reg, '') or item
			res.push(+item)
		)
		return res
	identity: (val)->
		return val
	compact: (arr)->
		res = []
		for item in arr
			if @identity(item)
				res.push(item)
			else
				res.push(0)
		return res
	# 带单位加减乘除运算 Arithmetic With Unit
	# example
	#   awu('+', 1, 2, 3, 4) => 10
	#   awu('-', 10, 4, 3, 2, 1) => 0
	awu: (type)->
		args = [].slice.call(arguments, 1)
		args = @compact(args)
		unit = @getUnit(args)
		args = @withOutUnit(args) 
		switch type
			when '+'
				step = (a, b)-> a + b
				break
			when '-'
				step = (a, b)-> a - b
				break
			when '*'
				step = (a, b)-> a * b
				break
			when '/'
				step = (a, b)-> a / b
				break
		res = args.shift()
		while(args.length)
			item = args.shift()
			res = step(res, item)
		unit(res)
}

# 工具方法
_util = {
	# class creator helper
	cCtr: (ctor, statics)->
		$.extend(ctor.prototype, statics)
		return ctor
	# 对数组前n项求和
	# params
	# 	@arr : {Array}
	# 	@n   : {Int}
	# return 
	# 	@arr : {Array}
	# example
	# 	input: [1,2,3,4,5], 3
	# 	output: 6
	getArrSum: (arr, n)->
		i = 0
		sum = 0
		while(i < n)
			sum += arr[i]
			i++
		return sum
	# 对于给定数组，返回其和数组
	# params
	# 	@arr : {Array}
	# return
	# 	@arr : {Array}
	# example
	# 	input: [1,2,3,4,5]
	# 	output: [1,3,6,10,15]
	getSumArr: (arr)->
		ts = []
		len = arr.length
		while(len)
			ts[len - 1] = @getSum(arr, len)
			len--
		return ts
	# 对于给定数组 , 求其前n项的和
	getSum: (arr, n)->
		res = 0
		n = n or arr.length
		for a, i in arr
			if i < n then res += a
		return res 
	# 首字母大写
	firstLetterUpper: (str)->
		str.replace(/^[a-z]{1}/, (match)->
			return match.toUpperCase()
		)
	# 首字母小写
	firstLetterLower: (str)->
		str.replace(/^[a-z]{1}/, (match)->
			return match.toLowerCase()
		)
}

# 映射辅助类Map
class Map 
	constructor: (opts)->
		@_data = opts.data or {}
		@_root = opts.root or window
		@defaultDomain = opts.defaultDomain or 'Custom'
		@
	# set逻辑的入口函数
	set: ->
		switch typeof arguments[0]
			when 'string'
				func = '_set'
			else
				func = '_setObj'
		return @[func].apply(@, arguments)
	# params
	# 	@obj  ｛Object｝key值为字符串，value值为放入map中的类
	# 	@domain ｛String｝根节点
	# example 
	# 	_setObj({
	# 		'A.B.C': ClassA
	# 		'A.B.D': ClassB
	# 	}, 'my') =>
	# 	window.my.A.B.C = ClassA
	# 	window.my.A.B.D = ClassB
	_setObj: (obj, domain)->
		for key, value of obj
			@_set(key, value, domain)
		return @
	_set: (name, ctor, domain)->
		domain = domain or @defaultDomain
		name = "#{domain}.#{name}"
		_name = ''
		name = name.replace(/[a-zA-Z]+$/, (match)->
			_name = U.firstLetterLower(match)
			return U.firstLetterUpper(match)
		)
		@_data[_name] = name
		arr = name.split('.')
		target = arr.pop()
		root = @_root

		while(name = arr.shift())
			if(not root[name]) then root[name] = {}
			root = root[name]
		if(root[target])
			@onError("namespace conflict at #{target}")
		root[target] = ctor
		@
	get: (name)->
		name = U.firstLetterLower(name)
		arr = @_data[name].split('.')
		ctor = @_root
		while(name = arr.shift())
			ctor = ctor[name]
		return ctor
	onError: (msg)->
		console.log(msg)


class Queue
	constructor: (opts)->
		# 队列由对象结构实现（方便修改），通过_order保证其顺序
		@_q = {}
		@_order = []
		@
	find: (name)->
		name and @_q[name]
	push: (name, func)->
		args = [].slice.call(arguments, 2)
		exist = @find(name)
		if(exist)
			# 参数均为object则合并
			if(exist.length is 2 and typeof exist[1] is 'object' and args.length is 1 and typeof args[0] is 'object' )
				exist[1] = $.extend({}, exist[1], args[0])
			else
				exist.concat(args)
		else
			@_order.push(name)
			args.unshift(func)
			@_q[name] = args
	next: ->
		callback = =>
			@next()
		if @_order.length
			name = @_order.shift()
			handle = @find(name)
			if(handle)
				handle.push(callback)
				handle.shift().apply(null, handle)
				@delete(name)
			else
				@next()
	delete: (name)->
		delete @_q[name]

U = $.extend({}, _math, _util, {
	Map: Map
	Queue: Queue
})

## Track
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

# variable accelerated motion
# opts = {
# 	v0: 初始速度
# 	vt: 末速度
# 	t: 总时间(s)
# }
class Vam extends Parabola
	constructor: (opts)->
		v0 = opts.v0
		vt = opts.vt
		t = opts.t
		s = opts.s
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

Track.push(
	'vam': Vam
	'cam': Cam
, 'Physics')

# 自由落体弹跳运动
class FreeFall extends Image
	constructor: (opts)-> 
		@opts = opts or {}
		super
		@v0 = opts.v0
		@a = 5
		@b = 0
		@c = 0
		@_derec = 0
		@opts.type = 'decay'
		@ym = opts.ym
		@times = 1
		if(opts.times)
			@ym /= opts.times
			@times = opts.times
		@_t = U.beAccuracy( Math.sqrt(@ym/5), 2 )
		@_sumT = 0
	isOnEnd: (x)->
		return if @_sumT then x > @_sumT else x > @_t
	_check: (x, method)->
		switch @opts.type
			when 'decay'
				if @_t < 0.01 then return @ym * @.times
				p = @opts.data?.decay or 0.8
				x -= @_sumT
				if x > @_t
					@_derec = ++@_derec%2
					@_sumT += @_t
					x -= @_t
					if(@_derec)
						vt = 10 * @_t * p
						@a = 5
						@b = - vt
						@c = @ym
						@_t = vt / 10
						@yn = vt * vt / 20
					else
						@b = 0
						@a = 5
						@c = @ym - @yn
				return @[method](x)
		super
	_getY: (x)->
		return (@a*x*x + @b*x + @c) * @times
	getX: (x)->
		return (@v0 * x)*@times;
T.push('freeFall', FreeFall)
## cssHandler
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

Css = C = {
	handle: (css, dom, opts)->
		return new Handler(css, dom, opts)
	spreadCss: (cCss, funcs)->
		return spreader.extend(cCss, funcs)
}

## matrix
C.spreadCss(['rotate', 'translate', 'scale'], {
	related: true,
	get: ($dom, type)->
		cssName = @gcc('transform')
		matrix = $dom.css(cssName)
		
		if(/\d+/.test(matrix))		
			matri = []
			matrix.replace(/[\d.]+/g, (match)->
				matri.push( +match )
				return match
			)
			a = matri[0]
			b = matri[1]
			c = matri[2]
			d = matri[3]
			e = matri[4]
			f = matri[5]
			sx = Math.sqrt(a * a + b * b)
			sy = Math.sqrt(c * c + d * d)
			sin = c / sy
			cos = a / sx
			deg = U.getDeg(sin, cos)
			y =  f * cos / sy - e * sin / sx
			x = ( e / sx + y * sin ) / cos
			res = 
				rotate: deg
				translate: x + ',' + y
				scale: sx + ',' + sy
		else
			res = 
				rotate: 0
				translate: '0,0'
				scale: '0,0'
		return if type then res[type] else res
	set: ($dom, css, callback)->
		cssName = this.gcc('transform')
		sx = 1
		sy = 1
		sin = 0
		rad = 0
		cos = 1
		x = 0
		y = 0

		for va, cs of css
			switch va
				when 'rotate'
					rad = +cs * Math.PI / 180
					sin = Math.sin(rad)
					cos = Math.cos(rad)
					break 
				when 'translate'
					arr = cs.split(',')
					x = +arr[0]
					y = +arr[1]
					break 
				when 'scale'
					arr = cs.split(',')
					sx = +arr[0]
					sy = +arr[1]
					break

		a = sx * cos
		b = -sx * sin
		c = sy * sin
		d = sy * cos
		e = sx * ( x * cos - y * sin )
		f = sy * ( x * sin + y * cos )

		res = {}
		res[cssName] = 'matrix(' + [a, b, c, d, e, f].join(',') + ')'
		$dom?.css(res)
		callback?()
		return res
})

getTrack = (track, opts)->
	if(typeof track is 'string')
		# todo
	else if($.isArray(track))
		if( $.isArray(track[0]) )
			ctor = T.mix(track, opts)
			track = new ctor(opts)
		else
			opts = $.extend({},opts, track[1])
			ctor = T.map.get(track[0])
			track = new ctor(opts)
	return track

## motion
$.fn.motion = (css, track, callback, opts)->
	opts = opts or {}
	# get track
	track = getTrack(track, opts)

	$(this).each((ind, dom)->
		# get step
		if($.isFunction(css))
			step = css
		else
			handler = C.handle(css, $(dom))
			step = handler.step

		t = 0
		timer = setInterval(->
			p = track.getSp(t)
			if(t and not track.getY(t) and track.opts.type is 'stop')
				clearInterval(timer)
				$(dom).animating = false
				return callback()
			step(p, track, t)
			opts.step?(p)
			t = U.beAccuracy(t + 0.04, 2)
		, 40)
	)

$.fn.move = (track, callback, opts)->
	opts = opts or {}
	# get track
	track = getTrack(track, opts)

	$(this).each((ind, dom)->
		o = $(dom).offset()
		step = (x, y)->
			$(dom).css(
				left: o.left + x + 'px'
				top: o.top + y + 'px'
			)
		stop = opts.stop
		t = 0
		timer = setInterval(->
			x = track.getX(t)
			y = track.getY(t)
			if(stop(x, y, t))
				clearInterval(timer)
				$(dom).animating = false
				return callback()
			step(x, y, track)
			opts.step?(x, y, track)
			t = U.beAccuracy(t + 0.04, 2)
		, 40)
	)
