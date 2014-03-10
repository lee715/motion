define([
	'../graphic/factory'
	'../promise/type'
	'../array/str2arr'
	'../array/slice'
	'../error'
], (F, type, str2arr, slice, err)->

	# holds all mixed tracks
	mixs = {}

	G = F.get('graphic')
	class Mixin extends G
		_getPos: (x)->
			arr = @tArr
			i = arr.length
			res = 0
			while i--
				if(x > arr[i])
					res = i+1
					break
			return res
		getY: (x)->
			pos = @_getPos(x)
			ts = @tArr
			iss = @insArr
			x -= ts[ pos - 1 ] or 0
			res = iss[ pos ].getY(x)
			return res
		getS: (x)->
			pos = @_getPos(x)
			sArr = @_getSArr()
			res = sArr[ pos - 1 ] or 0
			x -= @tArr[ pos - 1 ] or 0
			res += @insArr[pos].getS(x)
			return res
		_getSArr: ->
			if(@sArr) then return @sArr
			ts = @tArr
			iss = @insArr
			ss = []
			for t, i in ts
				ss.push(iss[i].getS( ts[i] - (ts[i-1] or 0 ) ))
			ss = U.getSumArr(ss)
			@sArr = ss
			ss

	Mix = 

		get: (name)->
			if type('string', name)
				mixs[name] and mixs[name].apply(null, slice.call(arguments, 1))
			else
				err('Mix.get requires a string parameter')
		# 混合方法用于将不同的轨迹拼接起来，自定义轨迹
		# params
		# 	name : {String} 非必须需要拼接的轨迹的数组
		# 	track : {Instance or Array} 基础轨迹的实例或构造参数
		# example
		# 	mix('lineAndPara',['line',1,0],['parabola',1,0])
		# 	=>
		# 		直线与抛物线的拼接轨迹
		mix: ->
			args = slice.call(arguments)
			ins = []
			if type('string', args[0])
				name = args.shift() 
			for arg in args
				# like ['line', 0, 1]
				if type('array', arg)
					ins.push(F.get.apply(F, arg))
				# case basic graphic class
				else if type('graphic', arg)
					ins.push(arg)
				# drop it and throw an error
				else
					err('Unrecognized Parameter', arg)
					continue
			class X extends Mixin
				constructor: (tArr)->
					super
					@insArr = insArr = @_insArr.slice()
					if(tArr)
						@tArr = tArr
						for ins, i in insArr

						@tArr = []
						for ins in insArr
							ins._t = @tArr[i]
					else
							@tArr.push(ins._t)
					@_t = U.getSum(@tArr)
					@tArr = U.getSumArr( @tArr )
					@
				_insArr: insArr
			# if name is supported, store X else return it
			if name
				mixs[name] = X
				Mix
			else
				X

)