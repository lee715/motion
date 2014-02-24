define([
	'../graphic/factory'
	'./mix'
	'../array/slice'
	'../array/str2arr'
	'../filter/filter'
	'../filter/add'
	'../function/copyWithContext'
	'../promise/type'
], (F, Mix, slice, str2arr, filter, add, copy, type)->

	class Track 
		constructor: (gpc, opts)->
			@opts = opts = opts or {}
			@gpc = gpc
			@timeCosted = opts.delay and opts.delay * 1000 or 0
			@status = 'initialize'
			# format options
			@t = opts.t or Infinity
			@baseline = bl = opts.baseline or gpc.getS(@t)
			# what to do when the animation is ended, default is stop
			@end = opts.end or 'stop'
			# prepare for filter
			unless fil = opts.filter then fil = [[], []]
			fil[0] = str2arr(fil[0])
			fil[0].push('beforeEnd')
			fil[1].push(->
				for k,i in @
					@[i] /= bl
				@
			)
			@filter = filter.apply(null, fil)
			@filter.beforeEnd(1)
			@start()
		promise: ->
			res = {}
			copy(res, @, 'stop restart repeat on off')
			copy(res, @filter)
			res
		on: (event, callback, context)->
			$.event.add(event, @, callback)
			this
		off: (event, context)->
		trigger: ->
			$.trigger.apply(@, arguments)
		start: ->
			@status = 'moving'
			m = setInterval(=>
					if(@status is 'stop') then return clearInterval(m)
					@timeCosted += 40
					val = @gpc.getS(@timeCosted/1000)
					console.log(val);
					val = @filter.filter([val])[0]
					console.log(val);
					# @trigger('progress', val)
					if @timeCosted >= @t * 1000
						@onEnd(m)
				, 40)
		stop: ->
			if @status is 'moving'
				@status = 'stop'	
		restart: ->
			if @status is 'stop'
				@status = 'moving'
				@start()
		repeat: ->
			if @status is 'end'
				@status = 'moving'
				@timeCosted = 0
				@start()
		onEnd: (timer)->
			switch @end
				when 'stop'
					clearInterval(timer)
					@status = 'end'
					@trigger('done')
				when 'stay'
					# 末速度
					vt = @gpc.getY(@t)
					# 总路程
					st = @gpc.getS(@t)
					# 将图形对象变为b为末速度的直线
					@gpc = F.get('line', 0, vt)
					# 将总路程加入过滤器中
					unless @filter.add
						@filter.register('add', add)
					@filter.add(st)
					# 清除已计算的时间
					@timeCosted = 0
					@trigger('stay')
				when 'repeat'
					@timeCosted = 0
					@trigger('repeat')
				when 'decay-t'
					p = @opts['decay-t'] or 0.8
					@t *= 0.8
					@timeCosted = 0
					@trigger('decay')

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

)