class VotatosController < ApplicationController
  before_action :require_signed_in, :except => [:plant, :pluck]
  before_action :set_votato, :only => [:plant, :pluck, :destroy]
  before_action :load_tvdb, :only => [:tvdb]

  def find
  end

  def tvdb
    if params[:media] == 'TV'
      search_query = params[:terms]
      @results = @tvdb.search(search_query)
    elsif params[:media] == 'Movie'
      flash[:notice] = 'Movies not supported yet.'
      redirect_to plantations_path
      return
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
    end
    render 'search'
  end

  def new_votato
    @tvdbobj = Tvdbobj.find(params[:tvdbobj_id])
    @plantations_options = '<option>' +
      current_user.plantations.collect(&:name).join('</option><option>') +
      '</option>'
  end

  def create_votato
    puts "-----#{params}-----"
    @votato = Votato.new(:tvdbobj_id => params[:tvdbobj_id])
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
