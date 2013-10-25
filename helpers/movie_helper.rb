module MovieHelper
  def current_movie_list
    session[:movie_list].map { |movie_id| Movie.find(movie_id) }
  end

  def add_to_session(movie_id)
    session[:movie_list] << movie_id unless session[:movie_list].include?(movie_id)
  end
end