define([
	'../public/motion',
	'../public/ex-css/matrix'
], function(m){
	ctrl = $('.ctrl-item').motion(
		[
			{'margin-bottom':'80px','transform': 'rotate(720deg)'},
			{'margin-left':40*1.732, 'margin-bottom': 40*1.732,'transform': 'rotate(720deg)'},
			{'margin-left':'80px','transform': 'rotate(720deg)'}
		], 
		'parabola 100 0 1000', 
		{t: 1, end: 'reverse'}
	);
	ctrl.on('reverse', function(){
		ctrl.stop();
	});
	$('#ctrl').click(function(){
		ctrl.restart();
	});
});