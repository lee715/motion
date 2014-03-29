define([
	'../public/motion',
	'../public/story',
	'../public/ex-ones/fallball'
], function(motion, story){
	var getRandomColor = function(){
		var cols = [ 0, 0 ,0], i = 0, rand;

		for( ; i < 3 ; i++ ) {
			rand = Math.round( Math.random() * 15 ).toString(16);
			cols[i] = rand + rand;
		}	

		return "#" + cols.join('');
	}


	// demo1
	var $ballsWDT = $('#ballsWithDiffTrack');
	var $msg = $ballsWDT.find('.msg');
	$msg.html('track: line 0 10 100');
	$ballsWDT.find('.ball').hide();
	$ballsWDT.find('.ball1').show();
	var ball1Ctrl = $ballsWDT.find('.ball1').motion({top: 300},'line 0 10 100', {t: 1});
	var ball2Ctrl = $ballsWDT.find('.ball2').motion({top: 300},'line 10 0 100', {t: 1});
	var ball3Ctrl = $ballsWDT.find('.ball3').motion({top: 300},'parabola 10 0 100', {t: 1});
	var storyInDemo1 = story({
		events: {
			time: function(t){
				return t == parseInt(t)
			}
		}
	});
	storyInDemo1
		.add(ball1Ctrl, 0, 1)
		.add(ball2Ctrl, 1, 2)
		.add(ball3Ctrl, 2, 3)
		.add(ball1Ctrl, 3, 4)
		.add(ball2Ctrl, 3, 4)
		.add(ball3Ctrl, 3, 4)
		.on('time', function(t){
			console.log('time', t);
			switch(t){
				case 1:
					$ballsWDT.find('.ball1').hide();
					$ballsWDT.find('.ball2').show();
					ball1Ctrl.percent(0)
					$msg.html('track: line 10 0 100');
					break;
				case 2:
					$ballsWDT.find('.ball2').hide();
					$ballsWDT.find('.ball3').show();
					ball2Ctrl.percent(0)
					$msg.html('track: parabola 10 0 100');
					break;
				case 3:
					ball3Ctrl.percent(0)
					$ballsWDT.find('.ball').show();
					$msg.html('lets see the difference');
					break;
			}
		})
	storyInDemo1.start();
	// demo2
	var demoCtrl = $('#demos').motion({'transform': 'rotateY(40deg)'}, 'line 5 0 100', {
		t: 1,
		endType: 'step'
	});
	// demoCtrl.on('progress', function(p){console.log(p)});
	var per = 0;
	$(document).keyup(function(e){
		var key = e.keyCode;
		if(key == 37){
			demoCtrl.step(-1);
		}else if(key == 39){
			demoCtrl.step(1);
		}else if(key == 38){
			demoCtrl.percent(per);
			per += 0.1;
			if(per>=1) per -= 1;
		}else if(key == 40){
			demoCtrl.stop()
		}
	})

	sq2 = Math.sin(Math.PI/4);
	r = 80;
	wid = 15;
	$('.container').css({
		'bottom': wid,
		'left': wid,
		'width': 2*r,
		'height': 2*r
	});
	$('#fallBallDemoCtrl .ctrl-item').css({
		left: r-wid,
		top: r-wid
	}).each(function(i, dom){
		$(dom).css('background', getRandomColor());
	});
	$('#fallBallDemoCtrl .ctrl').css({
		bottom: r,
		left: r,
		background: getRandomColor()
	});
	ctrl = $('#fallBallDemoCtrl div').not('.ctrl').motion(
		[
			{'transform': 'rotate(360deg)'},
			{'top':-wid},
			{'top':r-wid-r*sq2,left:r*sq2+r-wid},
			{left: 2*r-wid},
			{'top':r*sq2+r-wid,left:r*sq2+r-wid},
			{top: 2*r-wid},
			{'top':r*sq2+r-wid,left:r-wid-r*sq2},
			{left:-wid},
			{'top':r-wid-r*sq2,left:r-wid-r*sq2}
		],
		'line 100 0 100',
		{t: 0.8, endType: 'reverse'}
	);
	ctrl.on('reverse', function(){
		ctrl.stop();
	});
	$('#fallBallDemoCtrl .ctrl').click(function(){
		ctrl.restart();
	});
	var fallBallDemo_ctrls = [];
	$('#fallBallDemoCtrl .stop').click(function(){
		$.each(fallBallDemo_ctrls, function(i, ctrl){
			ctrl && ctrl.stop();
		});
	});
	$('#fallBallDemoCtrl .restart').click(function(){
		$.each(fallBallDemo_ctrls, function(i, ctrl){
			ctrl && ctrl.restart();
		});
	});
	setInterval(function(){
		var oldOnes = $('#fallBallDemo .ball1');
		$('#fallBallDemo').append('<div class="ball ball1 ball1_up"></div><div class="ball ball1 ball1_down"></div>');
		var $balls = $('#fallBallDemo .ball1').not(oldOnes);
		$balls.css({
			background: getRandomColor()
		});
		var ctrl1 = $balls.motion(
			[
				{'margin-top': -230},
				{'margin-top': 200, opacity: 0}
			],
			'fallball 1 100 0.8',
			{autoStart: true, delay: 1}
		);
		var b = Math.random()*10 + 5;
		var ctrl2 = $balls.motion(
			{'margin-left': 230}
			,
			'line 0 '+ b + ' 10' ,
			{autoStart: true, t: Infinity, baseline: 300, endType: 'stop'}
		);
		ctrl2.on('progress', function(p){
			if(p>1 || p == NaN){
				$balls.remove();
				ctrl1.destory();
				ctrl2.destory();
			}
		})
		fallBallDemo_ctrls.push(ctrl1);
		fallBallDemo_ctrls.push(ctrl2);
	}, 1000)
});