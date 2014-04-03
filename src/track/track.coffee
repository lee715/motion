define([
	'../graphic/factory'
	'./mix'
	'./controller'
	'../array/slice'
	'../array/str2arr'
	'../filter/filter'
	'../filter/add'
	'../function/copyWithContext'
	'../promise/type'
], (F, Mix, Controller, slice, str2arr, filter, add, copy, type)->

	class Track extends Controller
		constructor: (gpc, opts)->
			super
			@opts = opts = opts or {}
			@gpc = gpc
			@timeCircle = opts.delay and opts.delay * 1000 or 0
			@timeCosted = 0
			# format options
			@t = opts.t or gpc.t or Infinity
			@total = opts.total or Infinity
			@baseline = bl = opts.baseline or gpc.getS(@t)
			# what to do when the animation is ended, default is stop
			@endType = opts.endType or gpc.endType or 'stop'
			# prepare for filter
			unless fil = opts.filter then fil = [[], []]
			fil[0] = str2arr(fil[0])
			fil[0] = fil[0].concat(['translate','multi','beforeEnd','addtion'])
			fil[1].push('translate')
			fil[1].push('multi')
			fil[1].push(->
				for k,i in @
					@[i] /= bl
				@
			)
			fil[1].push('translate')
			@filter = filter.apply(null, fil)
			@filter.beforeEnd(1)
			opts.autoStart and @start()

		# 控制动画执行的正逆
		_reverse: false
		# 指示动画计算值的正负
		_minus: false
		# 返回控制器供外部控制动画运行时
		promise: ->
			res = super
			copy(res, @, 'start minus')
			copy(res, @filter)
			res
		start: ->
			@switch('moving')
			@trigger('start')
			@timer = m = setInterval(=> 
				val = @_step()
				if @timeCircle >= @t * 1000
					@onEnd(m, val)
			, @interval)
			@
		_step: (always)->
			if(@status is 'stop' and not always) then return clearInterval(@timer)
			console.log(@timeCircle, @timeCosted)
			now = @current()
			val = @gpc.getS(now)
			val = @filter.filter([val])[0]
			@trigger('progress', val)
			@triggerCE(@timeCircle/1000, val)
			return val
		minus: ->
			@filter.multi(-1)
			@_minus = not @_minus
		# 接收-1与1分别代表反向与正向
		step: (direction)->
			if @stopOrInit() and @endType is 'step'
				if(!!~direction is @_minus) then @minus()
				@start()
		onEnd: (timer, endVal)->
			endType = @endType
			gpc = @gpc
			switch endType
				when 'stop'
					@end()
				when 'stay'
					# 末速度
					vt = gpc.getY(@t)
					# 总路程
					st = gpc.getS(@t)
					# 将图形对象变为b为末速度的直线
					times = gpc.times
					@gpc = undefined
					@gpc = F.get('line', 0, vt, times)
					# 将总路程加入过滤器中
					@filter.translate(st)
					@t = Infinity
					# 清除已计算的时间
					@timeCircle = 0
					@stop()
					@start()
					@trigger('stay')
				when 'repeat'
					@timeCircle = 0
					@trigger('repeat')
				when 'reverse'
					@_reverse = not @_reverse
					@timeCircle = 0
					@trigger('reverse')
				when 'reverse-decay'
					@_reverse = not @_reverse
					unless @_reverse
						@filter.multi(0.8)
					@timeCircle = 0
					@trigger('reverse-decay')
				when 'step'
					@timeCircle = 0
					unless @_stepVal then @_stepVal = Math.abs(endVal)
					addVal = if @_minus then -@_stepVal else @_stepVal
					@filter.addtion(addVal)
					@stop()
					@trigger('step')
				when 'back'
					@timeCircle = 0
					@stop()
					@trigger('progress', 0)
					@trigger('back')
				else
					if gpc[endType]
						gpc[endType]()
						@t = gpc.t
						if gpc.isEnded
							return @end()
					@timeCircle = 0
					@trigger(endType)

	track = 
		get: (track, opts)->
			track = str2arr(track)
			gpc = @getGpc.apply(@, track)
			ctl = new Track(gpc, opts)
			ctl

		# get graphic required
		getGpc: (name)->
			args = slice.call(arguments)
			# like (['line', 1, 2, 3])
			if type('array', args[0]) 
				if args.length is 1
					args = args[0]
				else
					# TODO: for mixin ones
					return 
			if type('string', args[0])
				# mix ones go first
				unless gpc = Mix.get.apply(Mix, args)
					gpc = F.get.apply(F, args)
			gpc
		# extend custom events for all animations
		extendEvent: (name, judgeFunc)->
			Event[name] = judgeFunc

)