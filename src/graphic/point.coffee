define([
	'../array/last'
	'../array/slice'
	'../array/push'
	'../array/toArray'
	'../array/toArrayLike'
	'../array/toLength'
	'../promise/type'
], (last, slice, push, toArray, toArrayLike, toLength, Type)->
		class Point 
			constructor: ->
				args = slice.apply(arguments)
				if args.length is 1 and Type('array', args[0])
					args = args[0]
				if Type('string', last(args))
					type = args.pop()
				else 
					type = args.length + 'D'
				@type = type
				len = args.length
				switch type
					when '2D'
						len = 2
						break
					when '3D'
						len = 3
						break
					when 'polar'
						len = 2
						break
				toArrayLike(args.slice(0, len), @)
				# only for inner use
				@be = 'point'
				@
			set: ->
				args = slice.apply(arguments)
				if args.length is 1 and Type('array', args[0])
					args = args[0]
				args = toArray(arguments, 0, len)
				len = @length
				while len--
					@[len] = args[len]
				@
			toIndex: (s)->
				map = 
					x: 0
					y: 1
					z: 2
					r: 0
					j: 1
				map[ s.toLowerCase() ]
			get: (s)->
				pos = toArray( @ )
				if Type('undefined', s)
					pos
				else
					s = @toIndex(s)
					pos[ s ]
			clone: ->
				args = @get()
				args.push(@type)
				new Point(args)
      toLength: (p)->
        if type('number', p) then p = [p]
        if Type('point', p) or Type('arrayLike', p)
          len = @length
          p = toLength(p, len)
          return p
        else
          return false
			# 平移变换
			translate: ->
				args = toArray(arguments)
				now = @get()
				for arg in args
					arg = @toLength(arg)
          if arg
            for a, i in arg
              now[i] += a
				@set(now)
				@
			# 对称变换
			sym: (p)->
				p = @toLength(p)
        if p
          now = @get()
          for i in [0..@length-1]
            now[i] = 2*(p[i]-now[i])
					@translate(now)
				else if Type('graphic', p)
					@sym( @getFootPoint(p) )
			# 求垂足
			getFootPoint: (line)->
				if @type is '2D'
					a = line.a
					b = line.b
					x = @get('x')
					y = @get('y')
					foot = []
					foot[0] = (y - b + x / a)*a / (a+1)
					foot[1] = a * foot[0] + b
					foot
)			