#-*- coding: utf-8 -*-#
class VotatosController < ApplicationController
  before_action :require_signed_in, :except => [:plant, :pluck]
  before_action :set_votato, :only => [:plant, :pluck, :destroy]
  before_action :load_tvdb, :only => [:query]

  def find
  end

  def query
    search_query = params[:terms]
    if search_query.nil?
      flash[:notice] = 'No search terms provided.'
      redirect_to find_votato_path
      return
    end
    @media = params[:media]
    if @media == 'TV'
      @results = @tvdb.search(search_query)
    elsif @media == 'Movie'
      @results = Tmdb::Movie.find(search_query)
    else
      flash[:error] = 'Invalid media type selected.'
      redirect_to find_votato_path
      return
    end
    search
  end

  def search
    @movies_or_tvs = []
    @results.each do |r|
      if @media == 'TV'
        series_id = r['seriesid'].to_i
        tvdbobj = Tvdbobj.where(:series_id => series_id).first
        if tvdbobj.nil?
          @movies_or_tvs << Tvdbobj.create(
            :series_id => series_id,
            :name => r['SeriesName'],
            :description => r['Overview'],
            :image_url => r['banner'])
        else
          @movies_or_tvs << tvdbobj
        end
      elsif @media == 'Movie'
        tmdb_id = r.id
        tmdbobj = Tmdbobj.where(:tmdb_id => tmdb_id).first
        if tmdbobj.nil?
          details = Tmdb::Movie.detail(r.id)
          @movies_or_tvs << Tmdbobj.create(
            :tmdb_id => tmdb_id,
            :name => details.title,
            :description => details.overview,
            :image_url => details.poster_path,
            :imdb_id => details.imdb_id)
        else
          @movies_or_tvs << tmdbobj
        end
      end
    end
    render 'search'
  end

  def new_tvdb_votato
    @tvdbobj = Tvdbobj.find(params[:obj_id])
    plantations = current_user.plantations.where(:media => 'TV')
    @plantations_options = '<option>' +
      plantations.collect(&:name).join('</option><option>') +
      '</option>'
  end
  def create_tvdb_votato
    @votato = Votato.new(:obj_id => params[:obj_id])
    @plantation = Plantation.find_by(:user_id => current_user.id, :name => params[:plantation])
    if @plantation.nil?
      flash[:error] = "You don't own that Plantation!"
      redirect_to new_votato
      return
    end
    @votato.plantation = @plantation
    @votato.save
    redirect_to @plantation
  end

  def new_tmdb_votato
    @tmdbobj = Tmdbobj.find(params[:obj_id])
    plantations = current_user.plantations.where(:media => 'Movie')
    @plantations_options = '<option>' +
      plantations.collect(&:name).join('</option><option>') +
      '</option>'
  end
  def create_tmdb_votato
    @votato = Votato.new(:obj_id => params[:obj_id])
    @plantation = Plantation.find_by(:user_id => current_user.id, :name => params[:plantation])
    if @plantation.nil?
      flash[:error] = "You don't own that Plantation!"
      redirect_to new_votato
      return
    end
    @votato.plantation = @plantation
    @votato.save
    redirect_to @plantation
  end

  def plant # upvote
    return unless user_signed_in? || @votato.plantation.privacy == 'Public'
    @votato.total += 1
    @votato.save
    redirect_to @votato.plantation
  end

  def pluck # downvote
    return unless user_signed_in? || @votato.plantation.privacy == 'Public'
    if @votato.total > 0
      @votato.total -= 1
      @votato.save
    end
    redirect_to @votato.plantation
  end

  def destroy
    @plantation = @votato.plantation
    @votato.destroy
    redirect_to @plantation
  end

  # before_action :set_votato, only: [:show, :edit, :update, :destroy]

  # # GET /votatos
  # # GET /votatos.json
  # def index
  #   @votatos = Votato.all
  # end

  # # GET /votatos/1
  # # GET /votatos/1.json
  # def show
  # end

  # # GET /votatos/new
  # def new
  #   @votato = Votato.new
  # end

  # # GET /votatos/1/edit
  # def edit
  # end

  # # POST /votatos
  # # POST /votatos.json
  # def create
  #   @votato = Votato.new(votato_params)

  #   respond_to do |format|
  #     if @votato.save
  #       format.html { redirect_to @votato, notice: 'Votato was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @votato }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @votato.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /votatos/1
  # # PATCH/PUT /votatos/1.json
  # def update
  #   respond_to do |format|
  #     if @votato.update(votato_params)
  #       format.html { redirect_to @votato, notice: 'Votato was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @votato.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /votatos/1
  # # DELETE /votatos/1.json
  # def destroy
  #   @votato.destroy
  #   respond_to do |format|
  #     format.html { redirect_to votatos_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_votato
      @votato = Votato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def votato_params
      params[:votato]
    end

    def load_tvdb
      unless @tvdb
        @tvdb = TvdbParty::Search.new(
          Rails.env.development? ? TVDB_SECRET_KEY : ENV['TVDB_SECRET_KEY'])
      end
    end
end
