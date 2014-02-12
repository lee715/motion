define([
	'util'
	'graphic/factory'
	'mix'
	'array/slice'
], (U, F, Mix, slice)->

	class Track 
	Track = 

		get: (name)->
			args = slice.call(arguments)
			len = args.length
			if type('object', args[len-1])
				opts = args.pop()
			else 
				opts = {}
			gpc = @getGpc.apply(@, args)
			
			unless opts.baseline
				opts.baseline = gpc.getY(Infinity)
			unless opts.end
				opts.end = 'stop'

		# get graphic required
		getGpc: (name)->
			args = slice.call(arguments)
			# like (['line', 1, 2, 3])
			if type('array', args[0]) 
				if args.length is 1
					args = args[0]
				else
					return @each.apply(@, args)
			if type('string', args[0])
				# mix ones go first
				unless gpc = Mix.get.apply(Mix, args)
					gpc = factory.get.apply(factory, args)

)