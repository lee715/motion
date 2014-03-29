define([
	'../../public/motion',
	'../../public/ex-ones/fallball'
], function(motion,F){
	// var fall = F.get('fallball');
	// var getRandomColor = function(){
	// 	var cols = [ 0, 0 ,0], i = 0, rand;

	// 	for( ; i < 3 ; i++ ) {
	// 		rand = Math.round( Math.random() * 15 ).toString(16);
	// 		cols[i] = rand + rand;
	// 	}	

	// 	return "#" + cols.join('');
	// }
	// var ctl = $('#demos').motion({'transform': 'rotateY(40deg)'}, 'fallball 5 0 100', {
	// 	t: 1,
	// 	endType: 'step'
	// });
	// // ctl.on('progress', function(p){console.log(p)});
	// var per = 0;
	// $(document).keyup(function(e){
	// 	var key = e.keyCode;
	// 	if(key == 37){
	// 		ctl.step(-1);
	// 	}else if(key == 39){
	// 		ctl.step(1);
	// 	}else if(key == 38){
	// 		ctl.percent(per);
	// 		per += 0.1;
	// 		if(per>=1) per -= 1;
	// 	}else if(key == 40){
	// 		ctl.stop()
	// 	}
	// })

	// sq2 = Math.sin(Math.PI/4);
	// r = 80;
	// wid = 15;
	// $('.container').css({
	// 	'bottom': wid,
	// 	'left': wid,
	// 	'width': 2*r,
	// 	'height': 2*r
	// });
	// $('#demo2 .ctrl-item').css({
	// 	left: r-wid,
	// 	top: r-wid
	// }).each(function(i, dom){
	// 	$(dom).css('background', getRandomColor());
	// });
	// $('#demo2 .ctrl').css({
	// 	bottom: r,
	// 	left: r,
	// 	background: getRandomColor()
	// });
	// ctrl = $('#demo2 div').not('.ctrl').motion(
	// 	[
	// 		{'transform': 'rotate(360deg)'},
	// 		{'top':-wid},
	// 		{'top':r-wid-r*sq2,left:r*sq2+r-wid},
	// 		{left: 2*r-wid},
	// 		{'top':r*sq2+r-wid,left:r*sq2+r-wid},
	// 		{top: 2*r-wid},
	// 		{'top':r*sq2+r-wid,left:r-wid-r*sq2},
	// 		{left:-wid},
	// 		{'top':r-wid-r*sq2,left:r-wid-r*sq2}
	// 	],
	// 	'line 100 0 100',
	// 	{t: 0.8, endType: 'reverse'}
	// );
	// ctrl.on('reverse', function(){
	// 	ctrl.stop();
	// });
	// $('#demo2 .ctrl').click(function(){
	// 	ctrl.restart();
	// });
	// var demo3_ctrls = [];
	// $('#demo2 .stop').click(function(){
	// 	$.each(demo3_ctrls, function(i, ctrl){
	// 		ctrl && ctrl.stop();
	// 	});
	// });
	// $('#demo2 .restart').click(function(){
	// 	$.each(demo3_ctrls, function(i, ctrl){
	// 		ctrl && ctrl.restart();
	// 	});
	// });
	// setInterval(function(){
	// 	var oldOnes = $('#demo3 .ball1');
	// 	$('#demo3').append('<div class="ball ball1 ball1_up"></div><div class="ball ball1 ball1_down"></div>');
	// 	var $balls = $('#demo3 .ball1').not(oldOnes);
	// 	$balls.css({
	// 		background: getRandomColor()
	// 	});
	// 	var ctrl1 = $balls.motion(
	// 		[
	// 			{'margin-top': -230},
	// 			{'margin-top': 200, opacity: 0}
	// 		],
	// 		'fallball 1 100 0.8',
	// 		{autoStart: true, delay: 1}
	// 	);
	// 	var b = Math.random()*10 + 5;
	// 	var ctrl2 = $balls.motion(
	// 		{'margin-left': 430}
	// 		,
	// 		'line 0 '+ b + ' 10' ,
	// 		{autoStart: true, t: 2, baseline: 300, endType: 'stay'}
	// 	);
	// 	ctrl2.on('progress', function(p){
	// 		if(p>1){
	// 			$balls.remove();
	// 			ctrl1.destory();
	// 			ctrl2.destory();
	// 		}
	// 	});
	// 	demo3_ctrls.push(ctrl1);
	// 	demo3_ctrls.push(ctrl2);
	// }, 500)
});