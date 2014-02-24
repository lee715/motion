define([
	'../promise/type'
	'../array/str2arr'
	'../array/insert'
	'../array/indexOf'
], (type, str2arr, insert, indexOf)->

	class Filter
		constructor: (orders, funcs)->
			@orders = orders = str2arr(orders)
			@stack = {}
			if not type('array', funcs)
				_funcs = []
				for order in orders
					_funcs.push(funcs[order] or ->)
				funcs = _funcs
			for order, i in orders
				@stack[order] = [funcs[i]]
				@[order] = ((order)->
						(param)=>
							@stack[order].push(param)
					).call(@, order)
			@
		register: (name, func, prev)->
			os = @orders
			ind = prev and indexOf(os, prev) or 0
			insert(os, name, ind+1)
			@stack[name] = [func]
			@
		filter: (p)->
			os = @orders
			st = @stack
			for o in os
				arr = st[o]
				func = arr[0]
				params = arr.slice(1)
				while pa = params.shift()
					if func.call(p, pa) is false then return p
			p
	filter = (orders, funcs)->
		new Filter(orders, funcs)
)	