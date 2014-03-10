define([
	'../css/extend'
	'../css/gcc'
], (extend, gcc)->
	extend('rotate translate scale', {
		related: true,
		get: ($dom, type)->
			cssName = gcc('transform')
			matrix = $dom.css(cssName)
			
			if(/\d+/.test(matrix))		
				matri = []
				matrix.replace(/[\d.]+/g, (match)->
					matri.push( +match )
					return match
				)
				a = matri[0]
				b = matri[1]
				c = matri[2]
				d = matri[3]
				e = matri[4]
				f = matri[5]
				sx = Math.sqrt(a * a + b * b)
				sy = Math.sqrt(c * c + d * d)
				sin = c / sy
				cos = a / sx
				deg = U.getDeg(sin, cos)
				y =  f * cos / sy - e * sin / sx
				x = ( e / sx + y * sin ) / cos
				res = 
					rotate: deg
					translate: x + ',' + y
					scale: sx + ',' + sy
			else
				res = 
					rotate: 0
					translate: '0,0'
					scale: '0,0'
			return if type then res[type] else res
		set: ($dom, css, callback)->
			cssName = gcc('transform')
			sx = 1
			sy = 1
			sin = 0
			rad = 0
			cos = 1
			x = 0
			y = 0

			for va, cs of css
				switch va
					when 'rotate'
						rad = +cs * Math.PI / 180
						sin = Math.sin(rad)
						cos = Math.cos(rad)
						break 
					when 'translate'
						arr = cs.split(',')
						x = +arr[0]
						y = +arr[1]
						break 
					when 'scale'
						arr = cs.split(',')
						sx = +arr[0]
						sy = +arr[1]
						break

			a = sx * cos
			b = -sx * sin
			c = sy * sin
			d = sy * cos
			e = sx * ( x * cos - y * sin )
			f = sy * ( x * sin + y * cos )

			res = {}
			res[cssName] = 'matrix(' + [a, b, c, d, e, f].join(',') + ')'
			$dom?.css(res)
			callback?()
			return res
	})
)