define([
	'array/last'
	'array/slice'
	'array/push'
	'array/toArray'
	'array/toArrayLike'
	'promise/type'
], (last, slice, push, toArray, toArrayLike, type)->
		class Point 
			constructor: ->
				args = slice.apply(arguments)
				if type('string', last(args))
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
				toArrayLike(@, args.slice(0, len))
				# only for inner use
				@be = 'point'
				@

			set: ->
				len = @length
				args = toArray(arguments, 0, len)
				while --len
					@[len] = args[len]
				@
			get: ->
				toArray( @ )
			translate: ->
				args = toArray(arguments)
				now = @get()
				for arg in args
					if type('arrayLike', arg)
)			