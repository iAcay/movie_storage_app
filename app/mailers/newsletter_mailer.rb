class NewsletterMailer < ApplicationMailer
  def new_movie_email(movie)
    @movie = movie
    @director = movie.director
    
    NewsletterEmail.all.each do |email|
      mail(to: email, subject: "New movie #{@movie.name} has been added!")
    end
  end
end
