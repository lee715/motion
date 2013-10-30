$(function(){

	// utilities
	var hasOwnProperty;
	// 由传入的正弦余弦值得到其对应的角度
	Math.getDeg = function(sin, cos){
		var degS = Math.asin(sin) * 180 / Math.PI,
				degC = Math.acos(cos) * 180 / Math.PI,
				_degS = degS >= 0 ? 180 - degS : -degS - 180,
				_degC = -degC, res;
		if(parseInt(degS) === parseInt(degC) || parseInt(degS) === parseInt(_degC)){
			res = degS;
		}else{
			res = _degS;
		}
		return res;
	}

	// 乘方函数，n为阶数，可以是正负整数或0.5的倍数
	Math.p = function(x, n){
		var res = x, d = false, isInt, sqrt = false;
		if(n === 0) return 1;
		isInt = function(i){
			return i === parseInt(i);
		}
		if(n < 0){
			d = true;
			n = this.abs(n);
		}
		if(!isInt(n) && !isInt(2*n)) n = parseInt(n);
		if(!isInt(n)){
			n = n * 2;
			sqrt = true;
		} 
		while(--n > 0){
			res = res * x;
		}
		res = sqrt ? Math.sqrt(res) : res;
		return d ? 1 / res : res;
	}

	// 判断一个属性是否不是由原型继承而来


	var cssHandler, C, Track, Motion, cCtr, Map;

	// class creator
	cCtr = function(ctor, staticFuns){
		$.extend(ctor.prototype, staticFuns);
		return ctor;
	}

	Map = cCtr(function(funcMap, root, opts){
		this._map = funcMap;
		this._root = root;
		this.opts = opts || {};
		return this;
	}, {
		get: function(name){
			return this._map[name];
		},
		set: function(name, func){
			var arr = name.split('.'), root = this._root, target = arr.pop();
			if(this.get(_name)) return false;

			while(name = arr.shift()){
				domain = domain[name];
			} 
			if(domain[target]){
				return false;
			}else{
				domain[target] = ctor;
			}
			return this;

		}
	});

	var div = document.createElement('div');
	C = cssHandler = cCtr(function(css){
		
	}, {

	});

	Track = {
		Math: {
			Parabola: cCtr(function(opts){
				this.a = opts.a;
				this.b = opts.b;
				this.t = opts.t;
				this.reverse = opts.reverse;
				return this;
			}, {
				getY: function(x){
					return this.reverse ? this._getYReverse(x) : this._getY(x);
				},
				getS: function(x){
					return this.reverse ? this._getSReverse(x) : this._getS(x);
				},
				_getY: function(x){
					return this.a * x * x + this.b;
				},
				// 对x轴求面积（积分）
				_getS: function(x){
					return this.a * x * x * x / 3 + this.b * x;
				},
				_getYReverse: function(x){
					return this._getY(this.t - x);
				},
				_getSReverse: function(x){
					return this._getS(this.t) - this._getS(this.t - x);
				}
			}),
			Line: cCtr(function(opts){
				this.a = opts.a;
				this.b = opts.b;
				return this;
			},{
				getY: function(x){
					return this.a * x + this.b;
				},
				getS: function(x){
					return this.a * x * x / 2 + this.b * x;
				}
			}),
			CubicBezier: cCtr(function(x1, y1, x2, y2){
				this.x1 = x1;
				this.y1 = y1;
				this.x2 = x2;
				this.y2 = y2;
				return this;
			}, {
				getX: function(t){
					var m = Math, x1 = this.x1, x2 = this.x2;
					return -3 * (x1 + x2) * m.p(t, 3) + 3 * x2 * m.p(t, 2) + 3 * x1 * t;
				},	
				getY: function(t){
					var m = Math, y1 = this.y1, y2 = this.y2;
					return -3 * (y1 + y2) * m.p(t, 3) + 3 * y2 * m.p(t, 2) + 3 * y1 * t;
				},
				getL: function(t){
					var x1 = this.x1, x2 = this.x2, y1 = this.y1, y2 = this.y2, m = Math,
							a, b, c, d, e;

					a = 81 * ( m.p(x1+x2, 2) + m.p(y1+y2, 2) );
					b = -108 * ( (x1+x2)*x2 + (y1+y2)*y2 );
					c = 36*m.p(x2,2) - 54*m.p(x1,2) - 54*x1*x2 + 36*m.p(y2,2) - 54*m.p(y1,2) - 54*y1*y2;
					d = 36*x1*x2 + 36*y1*y2;
					e = 9*m.p(x1, 2) + 9*m.p(y1, 2);

					// TODO
				}
			})
		},
		// 物理学轨迹
		Physics: {
			/* variable accelerated motion
			   opts = {
						v0: 初始速度
						vt: 末速度
						t: 总时间(s)
			   }0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
			*/
			vam: function(opts){
				var a, b, self = this, t = opts.t, s = opts.s, v0 = opts.v0, vt = opts.vt;
				// if(s){ t = ( s - ( vt - v0 ) / 2 ) / v0; }
				a = ( vt - v0 )/( t * t );
				b = v0;
				return new Track.Math.Parabola({a: a, b: b, t: t, reverse: opts.reverse});
			},
			/* constant acceleration motion
			   opts = {
						v0: 初始速度
						vt: 末速度
						t: 总时间(s)
			   }
			*/
			cam: function(opts){
				var a, b, self = this;
				a = ( opts.vt - opts.v0 ) / opts.t;
				b = opts.v0;
				return new Track.Math.Line({a: a, b: b});
			},
			_cam: cCtr(function(opts){
				var a, b, self = this;
				this.a = ( opts.vt - opts.v0 ) / opts.t;
				this.b = opts.v0;
				this._yCahche
				return this;
			}, {
				_getIndex: function(x){

				},
				getY: function(x){

				}
			}),
		},
		// 自定义轨迹
		Custom: {
			Instance: {},
			Class: {}
		},
		mix: function(arr, opts){
			var t_arr = [], ins_arr = [], self = this;

			$.each(arr, function(index, item){
				var opts = item[1], res = self._getCtor(item[0]), ins;
				if(res){
					ins = res[1] ? new res[0](opts) : res[0](opts);
					t_arr.push(opts.t);
					ins_arr.push(ins);
				}
				
			});

			return new this.Mixin(ins_arr, t_arr, opts);
		},
		Mixin: cCtr(function(ins_arr, t_arr, opts){
			this.ins_arr = ins_arr;
			this.t_arr = this._getSumArr(t_arr);
			this.opts = opts || {};
			return this;
		}, {
			getY: function(x){
				var pos = this._getPos(x), ts = this.t_arr, 
						is = this.ins_arr, res;
				if(pos === ts.length){
					if(this.opts.stay){
						pos--;
						x = ts[ pos ] - ts[ pos - 1 ];
						res = is[ pos ].getY(x);
					}else{
						res = 0;
					}
				}else{
					x -= ts[ pos - 1 ] || 0;
					res = is[ pos ].getY(x);
				}
				return res;
			},
			getS: function(x){
				var pos = this._getPos(x), s_arr = this._getSArr(), res;

				res = s_arr[pos-1] || 0;
				if(pos !== s_arr.length){
					x -= this.t_arr[ pos - 1 ] || 0;
					res += this.ins_arr[pos].getS(x); 
				}
				return res;
			},
			// 得出时间t对应在该Mixin实例的第几段轨迹上
			_getPos: function(t){
				var arr = this.t_arr, i = arr.length, res = 0;

				while(i--){
					if(t > arr[i]){
						res = i+1;
						break;
					} 
				}
				return res;
			},
			_getSum: function(arr, len){
				var i = 0, sum = 0;
				while(i < len){
					sum += arr[i];
					i++;
				}
				return sum;
			},
			// 由参数数组生成一个新数组，新数组的第n项是原数组前项的和
			_getSumArr: function(arr){
				var ts = [], len = arr.length;
				while(len){
					ts[len - 1] = this._getSum(arr, len);
					len--;
				}
				return ts;
			},
			_getSArr: function(){
				if(this.s_arr) return this.s_arr;
				var ts = this.t_arr, is = this.ins_arr, ss = [];

				$.each(ts, function(index, t){
					ss.push(is[index].getS( ts[index] - (ts[index-1] || 0) ));
				}); 

				ss = this._getSumArr(ss);
				this.s_arr = ss;
				return ss;
			}
		}),
		_getCtor: function(funcName){
			var param = this.funcMap[funcName], 
					ctor = Track, name, arr, isCtor = true;
			if(!param) return false;
			arr = param.split('.');
			if(arr[0] === 'Custom') isCtor = false;
			while(name = arr.shift()){
				ctor = ctor[name];
			}
			return [ctor, isCtor];
		},
		_setCtor: function(funcName, ctor){
			var arr = funcName.split('.'), domain = Track, name, target = arr.pop();

			while(name = arr.shift()){
				domain = domain[name];
			} 
			if(domain[target]){
				return false;
			}else{
				domain[target] = ctor;
			}
			return this;
		},
		get: function(type){
			if(type === 'mixin'){
				return this.mix(arguments[1], arguments[2]);
			}else{
				var res = this._getCtor(type);
				return res[1] ? res[0] && new res[0](arguments[1]) : res[0](arguments[1]);
			}
		},
		funcMap: {
			'vam': 'Physics.vam',
			'line': 'Math.Line',
			'parabola': 'Math.Parabola'
		},
		pushToMap: function(name){
			var func = name.split('.').pop();
			func = func.toLowerCase();
			this.funcMap[func] = name;
			return this;
		},
		extend: function(name, ctor, proto){
			// var args = arguments;
			// switch(args.length){
			// 	case 2:
			// 		this._extendInstance.apply(this, args);
			// 	case 3:
			// 		this._extendClass.apply(this, args);
			// }
			name = 'Custom.' + name;
			proto = proto || {};
			if(this._setCtor(name, ctor)){
				this.pushToMap(name);
				$.extend(ctor.prototype, proto);
			}
		},
		_extendInstance: function(name, func){
			name = 'Custom.Instance.' + name;
			if(this._setCtor(name, func)){
				this.pushToMap(name);
			}
		},
		_extendClass: function(name, ctor, proto){
			name = 'Custom.Class.' + name;
			if(this._setCtor(name, ctor)){
				this.pushToMap(name);
				$.extend(ctor.prototype, proto);
			}
		}
	};

	Motion = {
		funcMap: {
			'd': 'Base.Discrete',
			'c': 'Base.Continuous'
		},
		Base: {
			Discrete: function(track, opts){
				var self = this, timer = t = 0, doing, vld = true;

				doing = function(){
					vld = opts.step.apply(this, opts);
				}

				while(vld){
					timer = track.getY(t);
					t += timer;
					setTimeout(doing, timer);
				}

			},
		},
		initCss0: function(dom, css){
			var css0 = {}, va;
			for( va in css ){
				if(va === 'rotate'){
					css0['rotate'] = 0;
					var arr = [];
					$(dom).css('transform').replace(/[-\d\.]+/g, function(m){
              arr.push(+m);
          });
          css0['rotate'] = Math.getDeg.apply(null, arr.slice(0,2).reverse());
				}else{
					css0[va] = css[va];
				}
			}
			$(dom).data('css0', css0);
		},
		css: function(dom, css){
			if(!$(dom).data('css0')){
				this.initCss0(dom, css);
			}
			var obj = {}, css0 = $(dom).data('css0'), va;
			for( va in css ){
				if(va === 'rotate'){
					obj['transform'] = "rotate(" + (css[va] + css0['rotate']) + "deg)";
				}else{
					obj[va] = css[va];
				}
			}
			$(dom).css(obj);
		}
		
	};

	// 扩展track
	Track.extend('vamBack', function(opts){
		var t = opts.t, s = opts.s || 100, ta, tl, sa, sl;
		tl = parseInt( t * 0.2 );
		ta = t / 2 - tl / 2;
		v0 = 0;
		if(!opts.reverse){
			sa = ( ta * s ) / ( 2 * ta + 3 * tl );
			sl = s - 2 * sa;
		}else{
			sa = s;
			sl = 0;
		}
		vt = 3 * sa / ta;
		vl = sl / tl;
		
		return Track.mix([
				['vam', {v0: v0, vt: vt, t: ta, s: sa, reverse: opts.reverse}],
				['line', {a:0, b:vl, t:tl, s: sl}],
				['vam', {v0: v0, vt: vt, t: ta, s: sa, reverse: !opts.reverse}]
			], opts);
	});
	

	window.track = Track;

	$.fn.track = function(type){
		var args = arguments;
		$(this).each(function(index, dom){
			if($(dom).data('track')) return;
			$(dom).data('track', Track.get.apply(Track, args));
		});
		return this;
	};

	var motionMap = {
		'd': 'motionDiscrete',
		'c': 'motionContinuous'
	};

	$.fn._motion = function(css, track, callback){
		$(this).track.apply(this, track);
		$(this).each(function(index, dom){
			var step, track = $(dom).data('track'), timer, t = 0;
			$(dom).animating = true;
			step = function(t){
				var s = track.getS(t), cssObj = css, curr = {};
				for( var va in cssObj ){
					curr[va] = cssObj[va] * s / 100;
				}
				Motion.css(dom, curr);
			}
			timer = setInterval(function(){
				step(t);
				if(t && !track.getY(t)){
					clearInterval(timer);
					$(dom).data('css0', '');
					$(dom).animating = false;
					callback();
				} 
				t += 0.04;
			}, 40);
		});
	};

	$.fn.motion = function(){
		var args = arguments;
		return $.fn._motion.apply(this, arguments);
		if(typeof args[0] === 'string'){
			var func = motionMap[args[0]];
			func && $(this)[func].apply(this, [].slice.apply(args,1));
		}
	};

	$.fn.motionDiscrete = function(track, opts){
		var self = this, timer = t = 0, doing, vld = true;

		doing = function(){
			vld = opts.step.apply(this, opts);
		}

		while(vld){
			timer = track.getY(t);
			t += timer;
			setTimeout(doing, timer);
		}
                                                                                                                                                                                        
	};

	$.fn.motionContinuous = function(track, opts){

	};
});

