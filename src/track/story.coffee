define([
	'./controller'
	'../function/copyWithContext'
], (Controller, copy)->

	class Story extends Controller
		constructor: (opts)->
			super
			opts = opts || {}
			@_ins = opts.ins or []
			@initTotalT()
			@timeCosted = 0
			if opts.autoStart then @start()

		promise: ->
			res = super
			copy(res, @, 'start add')
			res

		initTotalT: ->
			ins = @_ins
			total = 0
			for obj in ins
				if obj.endT > total then total = obj.endT
			@t = total
			@

		add: (trackCtrl, startT, endT)->
			if endT > @t then @t = endT
			@_ins.push(
				ins: trackCtrl
				startT: startT
				endT: endT
			)
			@

		start: ->
			@switch('moving')
			@timer = m = setInterval(=>
				@_step()
				if @timeCosted/1000 >= @t
					clearInterval(@timer)
			, 20)
			@

		_step: (alway)->
			if(@status is 'stop' and not always) then return clearInterval(@timer)
			now = @current()
			ins = @_ins
			for obj in ins
				if obj.endT >= now and obj.startT <= now
					if(obj.startT == now)
						@trigger('start', obj.ins)
					else if(obj.endT == now)
						@trigger('end', obj.ins)
					obj.ins.toSecond(now - obj.startT)
			# trigger custom events
			@triggerCE(now)

)