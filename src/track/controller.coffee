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
			@status = 'initialize'
			# for custom events
			if opts.events then Events = $.extend(Events, opts.events)
		current: ->
			@timeCosted += 20
			if @_reverse
				now = @t - @timeCosted/1000
			else
				now = @timeCosted/1000
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
			copy(res, @, 'stop on restart repeat toEnd destory percent reverse step toSecond')
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
				@timeCosted = 0
				@start()
		percent: (p)->
			@timeCosted = parseInt(p * @t * 1000) - 20
			@_step(true)
		toSecond: (t)->
			if t<=@t
				@timeCosted = t * 1000 - 20
				@_step(true)
			else
				@toEnd() 
		toEnd: ->
			if @endType is 'stop'
				@timeCosted = @t * 1000 - 20
				@_step()
				@end()
		end: ->
			clearInterval(@timer)
			@switch('end')
			@trigger('done')

	$.extend(Controller.prototype, Event)		
	return Controller
)