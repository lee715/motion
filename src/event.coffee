define([
	'./array/str2arr'
], (str2arr)->
	E = 
		on: (event, callback, context)->
			unless @_events then @_events = {}
			_e = @_events
			evts = str2arr(event)
			for evt in evts
				_e[evt] = _e[evt] or []
				_e[evt].push([callback, context])
			@
		trigger: (event, data)->
			unless @_events then return false
			if cbs = @_events[event]
				for cb in cbs
					cb[0].call(cb[1], data)
)