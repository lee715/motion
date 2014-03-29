define([
	'../array/slice'
	'../promise/type'
	'../object/create'
	'../function/wrap'
	'./graphic'
	'./line'
	'./log'
	'./lg'
	'./parabola'
	'./point'
], (slice, type, create, wrap)->

	names = 'graphic line log lg parabola point'.split(' ')
	funcs = slice.call(arguments, -6)
	basic = {}
	classes = {}
	for name, i in names 
		basic[name] = wrap(funcs[i])
		classes[name] = funcs[i]
	# holds Classes build by factory.create
	custom = {
		nial: 1
	}
	factory = 

		get: (name)->
			if typeof name is 'string'
				(basic[name] or custom[name]).apply(null, slice.call(arguments, 1))
			else
				name

		# 扩展基础图像类
		# params
		# 	name: {String}  类名
		# 	ctor: {Function} 构造函数
		# 	statics: {Object} 原型方法集,通常statics中需要包含getY方法
		#   parent: {String} 父类
		class: (name, ctor, statics, parent)->
			parent = parent and parent.toLowerCase() or 'graphic'
			Pnt = classes[parent or 'graphic'] 
			class X extends Pnt
				constructor: ctor
			$.extend(X.prototype, statics)
			console.log(custom)
			custom[name] = wrap(X)
			console.log(custom)
			true
)