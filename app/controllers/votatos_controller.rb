class VotatosController < ApplicationController
  before_action :require_signed_in :except => [:plant, :pluck]
  before_action :set_votato, :only => [:plant, :pluck]

  def find
  end

  def search
    @results = []
    20.times do
      @results << {
        :series_id => "id-#{Votato.generate_random_id(20)}",
        :title => "title-#{Votato.generate_random_id(10)}"
      }
    end
  end

  def new_votato
    @series_id = params[:series_id]
    @plantations_options = '<option>' +
      current_user.plantations.collect(&:name).join('</option><option>') +
      '</option>'
  end

  def create_votato
    @votato = Votato.new(:series_id => params[:series_id])
    @plantation = Plantation.where(
      :user_id => current_user,
      :name => params[:plantation]).first
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
  end

  def pluck # downvote
    return unless user_signed_in? || @votato.plantation.privacy == 'Public'
    if @votato.total > 0
      @votato.total -= 1
      @votato.save
    end
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
end
