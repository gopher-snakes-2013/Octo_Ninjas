$(document).ready(function(){
	$('#add-movie').click(function(event){
		event.preventDefault()

		var movie = $('#movie-title').val()

		$.ajax({

			url: '/add_movie',
			method: 'post',
			data: {movie_title: movie}

		}).done(function(serverData){
			$('#movie-list').append(serverData)
		})
	})
})