module MovieHelper
   def create_movie(movie_data)
    Movie.create(
      :title => movie_data.title,
      :synopsis => movie_data.synopsis, 
      :runtime => movie_data.runtime, 
      :critics_score => movie_data.ratings.critics_score, 
      :audience_score => movie_data.ratings.audience_score, 
      :pic => movie_data.posters.original
      )
   end

end
