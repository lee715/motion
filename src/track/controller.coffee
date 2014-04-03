define([
	'../function/copyWithContext'
	'../promise/type'
	'../event'
	'../array/slice'
], (copy, type, Event, slice)->
	Events = {}
	class Controller
		constructor: (opts)->
			opts = opts || {}
			@interval = opts.interval || 20;
			@status = 'initialize'
			# for custom events
			if opts.events then Events = $.extend(Events, opts.events)
		current: ->
			tCircle = @timeCircle += @interval
			tCosted = @timeCosted += @interval
			total = @total
			t = @t
			if tCosted > @total * 1000
				console.log(tCosted, @total * 1000)
				return @end()
			if @_reverse and t isnt Infinity
				if total is Infinity then total = t
				now = total - tCircle/1000
			else
				now = tCircle/1000
			if now > t
				times = parseInt(now/t)
				now = util.beAccuracy(now % t, 2)
				@fix and @fix(times)
			return now
		# trigger custom events
		triggerCE: ->
			args = slice.call(arguments, 0)
			evs = Events
			for name, func of evs
			  if func.apply(null, args)
			  	args.unshift(name)
			  	this.trigger.apply(this, args)
		promise: (res)->
			res = {}
			copy(res, @, 'stop on end back restart repeat toEnd destory percent reverse step toSecond')
			res
		switch: (status)->
			_status = @status
			@status = status
			@trigger('switch', status, _status)
		destory: ->
			clearInterval(@timer)
			delete @
		stop: ->
			if @status is 'moving'
				@switch('stop')
		reverse: ->
			if @stopOrInit()
				@_reverse = not @_reverse
		stopOrInit: ->
			~'stop initialize'.indexOf(@status)
		restart: ->
			if @stopOrInit()
				@switch('moving')
				@trigger('restart')
				@start()
		repeat: ->
			if @status is 'end'
				@switch('moving')
				@timeCircle = 0
				@start()
		back: ->
			@stop()
			@timeCircle = 0
			@timeCosted = 0
			@trigger('progress', 0)
			@trigger('back')
		reversible: ->
			if @t isnt Infinity
				if @total is Infinity then @total = @t
				return true
			else
				return false
		percent: (p)->
			if @reversible()
				@timeCircle = parseInt(p * @total * 1000) - @interval
				@_step(true)
		toSecond: (t)->
			if t<=@total and @reversible()
				@timeCircle = t * 1000 - @interval
				@timeCosted = t * 1000 - @interval
				@_step(true)
			else
				@toEnd() 
		toEnd: ->
			if @reversible()
				@timeCircle = @total * 1000 - @interval
				@_step()
			@end()
		end: ->
			clearInterval(@timer)
			@switch('end')
			@trigger('done')

	$.extend(Controller.prototype, Event)		
	return Controller
)