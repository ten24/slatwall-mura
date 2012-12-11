jQuery(document).ready(function(e){
	jQuery('html').on('click', 'div.sw-handle', function(e){
		
		e.preventDefault();
		if(jQuery('div#sw-fetools').hasClass('open')) {
			jQuery('div#sw-fetools').animate({left:'-200px'}, 100, function(e) {
				jQuery('div#sw-fetools').removeClass('open');
			});
		} else {
			jQuery('div#sw-fetools').animate({left:'0px'}, 100, function(e) {
				jQuery('div#sw-fetools').addClass('open');
			});
		}
		
	});
	
	jQuery('body').on('click', 'a.sw-submenu-toggle', function(e){
		
		e.preventDefault();
		if(!jQuery(this).hasClass('active')) {
			
			jQuery(this).closest('ul').find('ul').hide('fast');
			jQuery(this).closest('ul').find('ul').removeClass('open');
			jQuery(this).closest('ul').children('li').children('a').removeClass('active');
			jQuery(this).closest('li').find('ul').show('fast');
			jQuery(this).addClass('active');
		}
		
	});
});
