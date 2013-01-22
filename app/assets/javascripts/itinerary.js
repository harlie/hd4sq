$(function() {
	
	$(".edit-stop").click(function(){
		var stop = $(this).parents(".stop");
		edit_stop(stop);
	});
	
	$(".cancel-stop").click(function(){
		var stop = $(this).parents(".stop");
		cancel_edit_stop(stop);
	});
	
	$(".delete-stop").click(function(){
		var stop = $(this).parents(".stop");
		delete_stop(stop);
	});
	
	$(".save-stop").click(function(){
		var stop = $(this).parents(".stop");
		save_stop(stop);
	});
	
	var current_attr = {};
	
	function edit_stop(stop){
		stop_id  = stop.data("id");
		title_elem = stop.find(".title > h2");
		content_elem = stop.find(".content > p");
		
		current_attr[stop_id] = { title: title_elem.html(),
		 													content: content_elem.html()};
		
		title_elem.html('<input name="stop[name]" value="' + title_elem.text() + '" class = "stop-input">');
		content_elem.html('<textarea name="stop[shout]" class = "stop-input">' + content_elem.text() + '</textarea>');
		
		stop.find(".not-editing").hide();
		stop.find(".editing").show();

		input_elem = title_elem.find('input')
		input_elem.autocomplete({
			source: function( request, response ) {
			 $.ajax({
         url: "https://api.foursquare.com/v2/venues/suggestcompletion",
         dataType: "json",
         data: {
					 oauth_token: FOURSQUARE_TOKEN,
           limit: 5,
           query: request.term,
					 ll: LAT_LNG, 
					 radius: 2000
         },
         success: function( data ) {
           response( $.map( data.response.minivenues, function( item ) {
             return {
               value: item.name,
               id: item.id
             }
           }));
         }
       });
     },
     minLength: 3,
     select: function( event, ui ) {
       if ( ui.item ) {
				 $('<input>').attr({
				    type: 'hidden',
				    name: 'stop[venue_id]',
						value: ui.item.id,
				}).appendTo(stop.find('form'));
			 }
			
     }

			
		});
	}
	
	function save_stop(stop){
		stop_id  = stop.data("id");
		title_elem = stop.find(".title > h2");
		content_elem = stop.find(".content > p");
		stop_form = stop.find('form');
		stop_url = stop_form.attr('action');
		stop_data = stop_form.serialize();
		$.ajax({
			url: stop_url,
			type: "put",
			data: stop_data,
			success: function(data){
				title_elem.html('<p>' + data.name + '</p>'); 
				content_elem.html('<p>' + data.shout + '</p>');
				stop.find(".editing").hide();
				stop.find(".not-editing").show();
			}
		});
		

		
	}
	
	function cancel_edit_stop(stop){
		stop_id  = stop.data("id");
		title_elem = stop.find(".title > h2");
		content_elem = stop.find(".content > p");
		
		title_elem.html(current_attr[stop_id]['title']); 
		content_elem.html(current_attr[stop_id]['content']);
				
		stop.find(".editing").hide();
		stop.find(".not-editing").show();
		
	}
	
	function delete_stop(stop){
		stop_form = stop.find('form')
		
		if (confirm("Are you sure you want to delete this stop?  This action cannot be undone.")){
			$.ajax({
		                url: stop_form.attr('action'),
		                type: 'post',
		                dataType: 'script',
		                data: { '_method': 'delete' },
		                success: function() {
		                    stop.remove();
										
		                }
			})
		}
	}
})