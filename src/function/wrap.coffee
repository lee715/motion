define([
	'object/create'
], (create)->
		(Ctor)->
			->
				o = create(Ctor.prototype)
				Ctor.apply(o, arguments)
				o
)	