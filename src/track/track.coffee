define([
	'../graphic/factory'
	'./mix'
	'../array/slice'
	'../array/str2arr'
	'../filter/filter'
	'../filter/add'
	'../function/copyWithContext'
	'../promise/type'
	'../event'
], (F, Mix, slice, str2arr, filter, add, copy, type, Event)->

	Events = {}

	class Track 
		constructor: (gpc, opts)->
			@opts = opts = opts or {}
			@gpc = gpc
			@timeCosted = opts.delay and opts.delay * 1000 or 0
			@status = 'initialize'
			# format options
			@t = opts.t or gpc.t or Infinity
			@baseline = bl = opts.baseline or gpc.getS(@t)
			# what to do when the animation is ended, default is stop
			@endType = opts.endType or gpc.endType or 'stop'
			# prepare for filter
			unless fil = opts.filter then fil = [[], []]
			fil[0] = str2arr(fil[0])
			fil[0] = fil[0].concat(['translate','decay','beforeEnd','sbs'])
			fil[1].push((p)->
				@translate(p)
			)
			fil[1].push((p)->
				for k,i in @
					@[i] *= p
				@
			)
			fil[1].push(->
				for k,i in @
					@[i] /= bl
				@
			)
			@filter = filter.apply(null, fil)
			@filter.beforeEnd(1)
      # for custom events
      opts.events and Events = _.extend(Events, opts.events)
			opts.autoStart and @start()
		# 控制动画执行的正逆
		reverse: false
		# 控制动画计算值的正负
		minus: false
		# 返回控制器供外部控制动画运行时
		promise: ->
			res = {}
			copy(res, @, 'stop restart start repeat on toEnd destory')
			copy(res, @filter)
			res
		start: ->
			@status = 'moving'
			@timer = m = setInterval(=> 
				@step()
				if @timeCosted >= @t * 1000
					@onEnd(m)
			, 20)
			@
		destory: ->
			clearInterval(@timer)
			delete @
		step: ->
			if(@status is 'stop') then return clearInterval(@timer)
			@timeCosted += 20
			if @reverse
				now = @t - @timeCosted/1000
			else
				now = @timeCosted/1000
			val = @gpc.getS(now)
			val = @filter.filter([val])[0]
			@trigger('progress', val)
      # trigger custom events
      evs = Events
      for name, func of evs
        if func(@timeCosted/1000, val) then this.trigger(name)
		stop: ->
			if @status is 'moving'
				@status = 'stop'	
		restart: ->
			if @status is 'stop' or @status is 'initialize'
				@status = 'moving'
				@start()
		repeat: ->
			if @status is 'end'
				@status = 'moving'
				@timeCosted = 0
				@start()
		toEnd: ->
			if @endType is 'stop'
				@timeCosted = @t * 1000 - 20
				@step()
				@end()
		end: ->
			clearInterval(@timer)
			@status = 'end'
			@trigger('done')
		onEnd: (timer)->
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
					@gpc = F.get('line', 0, vt)
					# 将总路程加入过滤器中
					@filter.translate([st])
					@t = Infinity
					# 清除已计算的时间
					@timeCosted = 0
					@trigger('stay')
				when 'repeat'
					@timeCosted = 0
					@trigger('repeat')
				when 'reverse'
					@reverse = not @reverse
					@timeCosted = 0
					@trigger('reverse')
				when 'reverse-decay'
					@reverse = not @reverse
					unless @reverse
						@filter.decay(0.8)
					@timeCosted = 0
					@trigger('reverse-decay')
				when 'step-by-step'

				else
					if gpc[endType]
						gpc[endType]()
						@t = gpc.t
						if gpc.isEnded
							return @end()
					@timeCosted = 0
					@trigger(endType)
	$.extend(Track.prototype, Event)				

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