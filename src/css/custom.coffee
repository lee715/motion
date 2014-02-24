define([
	'./data'
], (Data)->

	custom = 
		# 判断一个css是否是自定义css
		isCustom: (name)->
			!!Data[ name ]
		getHandler: (name)->
			Data[ name ]
		# 获取自定义css值
		get: (dom, name)->
			handler = @getHandler(name)
			handler.get.call(@, dom, name)
		# 设置自定义css值
		set: (dom, name, value)->
			handler = @getHandler(name)
			data = {}
			if handler.related
				id = handler._id
				data[name] = value
				@queue.push(id, (data)=>
					handler.set.call(@, dom, data)
				, data)
			else
				data[name] = value
				handler.set.call(@, dom, data)
)