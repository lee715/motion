require([
	'jquery'
	'util'
	'track'
], ($, U, T)->

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

)