define([
	'../promise/type'
	'../array/str2arr'
	'../array/insert'
	'../array/indexOf'
  '../array/toLength'
	'../graphic/factory'
], (type, str2arr, insert, indexOf, toLength, F)->
  # 加减
  translate = (p)->
    @translate(p)
  # 乘除
  multi = (p)->
    now = @get()
    len = @length
    p = toLength(p, len)
    for i in [0..len-1]
      now[i] = now[i]*p[i]
    @set(now)
  # 对称
  sym = (p)->
    @sym(p)

  Funcs =
    translate: translate
    multi: multi
    sym: sym

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
        func = @getFunc(funcs[i])
				@stack[order] = [func]
				@[order] = ((order)->
						(param)=>
							@stack[order].push(param)
					).call(@, order)
			@
    getFunc: (func)->
      if(type('string', func))
        return Funcs[func]
      else
        return func
		register: (name, func, prev)->
			os = @orders
			ind = prev and indexOf(os, prev) or 0
			insert(os, name, ind+1)
      func = @getFunc(func)
			@stack[name] = [func]
			@
    extend: (name, func)->
      Funcs[name] = func
		filter: (p)->
			unless type('point', p)
				p = F.get('point', p)
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