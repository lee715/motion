require.config({
	paths: {
    'jquery': 'jquery-min',
    'motion': 'Motion',
    'cssHandler': 'CssHandler',
    'track': 'Track',
    'util': 'Utilities',
    'track-ex': 'track-ex'
  }
});

require([
	'jquery',
	'util',
	'motion'
], function($, U){
	var width = $('body').width();
	var height = $('body').height() ;
	var getRandomColor = function(){
		var cols = [ 0, 0 ,0], i = 0, rand;
		for( ; i < 3 ; i++ ) {
			rand = Math.round( Math.random() * 15 ).toString(16);
			cols[i] = rand + rand;
		}	
		return "#" + cols.join('');
	}

	function move($dom){
		var p = Math.random();
		var v0 = parseInt(p * 35 + 5);
		var times = parseInt(p * 95 + 5);
		var color = getRandomColor();
		$dom.css('background', color);
		$dom.move(['freeFall', {v0: v0, ym: height-10, times: times}], function(){console.log('end')}, {
			stop: function(x, y, t){
				off = $dom.offset();
				if(off.left > width ){
					$dom.remove();
					return true;
				}else{
					return false;
				}
			}
		});
	}

	setInterval(function(){
		var $d = $('<div class="div2"></div>');
		$('body').append($d);
		move($d);
	}, 100)
})