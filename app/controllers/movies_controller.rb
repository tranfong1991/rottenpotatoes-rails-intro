class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title_class, @release_date_class = ""
    @all_ratings = Movie.all_ratings;
    
     if session[:ratings].nil?
      session[:ratings] = Hash.new
      @all_ratings.each do |rating|
        session[:ratings][rating] = true
      end
    end
    
    if params[:sort].nil? and params[:ratings].nil?
      flash.keep
      redirect_to :action => 'index', :sort => session[:sort], :ratings => session[:ratings] and return
    end
    
    if !params[:sort].nil? and params[:sort] != session[:sort] 
      session[:sort] = params[:sort]
    end
    
    if !params[:ratings].nil? and params[:ratings] != session[:ratings]
      session[:ratings] = params[:ratings]
    end

    sort = session[:sort]
    @selected_ratings = session[:ratings]
    
    puts "@SELECTED_RATINGS"
    puts @selected_ratings

    case sort
    when "title"
      @title_class = "hilite"
    when "release_date"
      @release_date_class = "hilite"
    end
    
    @movies = Movie.where(:rating => @selected_ratings.keys).order(sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
