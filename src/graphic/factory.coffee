define([
	'jquery'
	'array/slice'
	'array/type'
	'graphic'
	'line'
	'log'
	'lg'
	'parabola'
], ($, slice, type)->

	names = 'graphic line log lg parabola'.split(' ')
	funcs = slice.call(arguments, 2)
	basic = {}
	for name, i in names 
		basic[name] = funcs[i]

	# holds Classes build by factory.create
	custom = {}

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
			Pnt = @get(parent)
			class X extends Pnt
				constructor: ctor
			$.extend(X.__super__, statics)
			custom[name] = X
			true
