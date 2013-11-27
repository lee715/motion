require([
	'jquery'
], ($)->

	# 默认所有数值计算结果的精度
	ACCUR = 6

	# Math扩展
	_math = {
		isInt: (x)->
			return x is parseInt(x)
		# 获取num的精度
		getAccuracy: (num)->
			return (num + '').split('.')[1]?.length or 0
		# 将num精度化
		beAccuracy: (num, accur)->
			accur = accur or ACCUR
			curAccur = this.getAccuracy(num)
			if curAccur <= accur
				res = num
			else
				k = this.power(10, accur)
				res = Math.round(num * k)/k
			return res
		# 乘方函数，n为阶数，可以是正负整数或0.5的倍数
		power: (x, n, accuracy)->
			res = x, isInt = this.isInt, bA = this.beAccuracy
			# isRec 标识结果是否需求倒
			isRec = false
			# isSqrt 标识结果是否需开方
			isSqrt = false

			if n is 0 then return 1
			if n < 0
				isRec = true
				n = Math.abs(n)
			if not isInt(n) and isInt(2*n)
				n = n * 2
				isSqrt = true
			if not isInt(2*n) then n = parseInt(n)

			while(--n > 0)
				res = res * x
			if isSqrt then res = bA(Math.sqrt(res))
			if isRec then res = bA(1 / res)
			return res
		# 由传入的正弦余弦值得到其对应的角度
		getDeg: (sin, cos)->
			bA = this.beAccuracy
			degS = Math.asin(sin) * 180 / Math.PI
			degC = Math.acos(cos) * 180 / Math.PI
			_degS = degS >= 0 ? 180 - degS : -degS - 180
			_degC = -degC
			p = parseInt
			if(p(degS) is p(degC) or p(degS) is p(_degC)){
				res = degS
			}else{
				res = _degS
			}
			return bA(res)
		# 得到单位
		getUnit: (arr)->
			unless $.isArray(arr) then arr = [arr]
			res = false
			reg = /[a-zA-Z]+/g
			for str in arr
				str.replace(reg, (match)->
					res = match
				)
				if res then break
			return res
		withOutUnit: (arr)->
			res = []
			if not $.isArray(arr) then arr = [arr]
			$.each(arr, (index, item)->
				item.replace(reg, '')
				res.push(+item)
			)
			return res
		# 带单位加减乘除运算 Arithmetic With Unit
		# example
		#   awu('+', 1, 2, 3, 4) => 10
		#   awu('-', 10, 4, 3, 2, 1) => 0
		awu: (type)->
			args = [].slice.call(arguments, 1)
			unless(unit = @getUnit(args)) then return
			args = @withOutUnit(args) 
			switch type
				when '+'
					step = (a, b)-> a + b
					break
				when '-'
					step = (a, b)-> a - b
					break
				when '*'
					step = (a, b)-> a * b
					break
				when '/'
					step = (a, b)-> a / b
					break
			res = args.shift()
			while(item = args.shift())
				res = step(res, item)
			res
	}

	# 工具方法
	_util = {
		# class creator helper
		cCtr: (ctor, statics)->
			$.extend(ctor.prototype, statics)
			return ctor
		# 对数组前n项求和
		# params
		# 	@arr : {Array}
		# 	@n   : {Int}
		# return 
		# 	@arr : {Array}
		# example
		# 	input: [1,2,3,4,5], 3
		# 	output: 6
		getArrSum: (arr, n)->
			i = 0, sum = 0
			while(i < n)
				sum += arr[i]
				i++
			return sum
		# 对于给定数组，返回其和数组
		# params
		# 	@arr : {Array}
		# return
		# 	@arr : {Array}
		# example
		# 	input: [1,2,3,4,5]
		# 	output: [1,3,6,10,15]
		getSumArr: (arr)->
			ts = [], len = arr.length
			while(len)
				ts[len - 1] = @getSum(arr, len)
				len--
			return ts
		# 首字母大写
		firstLetterUpper: (str)->
			str.replace(/^[a-z]{1}/, (match)->
				return match.toUpperCase()
			)
		# 首字母小写
		firstLetterLower: (str)->
			str.replace(/^[a-z]{1}/, (match)->
				return match.toLowerCase()
			)
	}

	# 映射辅助类Map
	class Map 
		constructor: (opts)->
			@_data = opts.data or {}
			@_root = opts.root or window
			@defaultDomain = opts.defaultDomain or 'Custom'
			@
		# set逻辑的入口函数
		set: ->
			switch arguments.length
				when 2
					func = '_setObj'
				when 3
					func = '_set'
			return @[func].apply(@, arguments)
		# params
		# 	@obj  ｛Object｝key值为字符串，value值为放入map中的类
		# 	@domain ｛String｝根节点
		# example 
		# 	_setObj({
		# 		'A.B.C': ClassA
		# 		'A.B.D': ClassB
		# 	}, 'my') =>
		# 	window.my.A.B.C = ClassA
		# 	window.my.A.B.D = ClassB
		_setObj: (obj, domain)->
			for key, value of obj
				@_set(key, value, domain)
		_set: (name, ctor, domain)->
			domain = domain or @defaultDomain
			name = "#{domain}.#{name}"
			_name = ''
			name = name.replace(/[a-zA-Z]+$/, (match)->
				_name = U.firstLetterLower(match)
				return U.firstLetterUpper(match)
			)
			@_data[_name] = name
			arr = name.split('.')
			target = arr.pop()
			root = @_root

			while(name = arr.shift())
				domain = domain[name]
				if(not domain) then domain = {}
			if(domain[target])
				@onError("namespace conflict at #{target}")
			domain[target] = ctor
			@
		get: (name)->
			name = U.firstLetterLower(name)
			arr = @_data[name].split('.')
			ctor = @_root
			while(name = arr.shift()){
				ctor = ctor[name]
			}
			return ctor
		onError: (msg)->
			console.log(msg)
	})

	class Queue
		constructor: (opts)->
			@_q = {}
			@_order = []
			@
		find: (name)->
			@_q[name]
		push: (name, func)->
			args = [].slice.apply(arguments, 2)
			exist = @find(name)
			if(exist)
				# 参数均为object则合并
				if(exist.length is 2 and $.isObject(exist[1]) and args.length is 1 and $.isObject(args[0]) )
					exist[1] = $.extend({}, exist[1], args[0])
				else
					exist.concat(args)
			else
				@_order.push(name)
				args.unshift(func)
				@_q[name] = args
		next: ->
			callback = =>
				@next()
			name = @_order.shift()
			handle = @find(name)
			if(handle)
				handle.push(callback)
				handle.shift().apply(null, handle)
				@delete(name)
			else
				@next()
		delete: (name)->
			delete @_q[name]

	return $.extend({}, _math, _util, {
		Map: Map
		Queue: Queue
	})
)