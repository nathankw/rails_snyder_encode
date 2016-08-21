class UberonsController < ApplicationController
  before_action :set_uberon, only: [:show, :edit, :update, :destroy]

  # GET /uberons
  # GET /uberons.json
  def index
    @uberons = Uberon.all
  end

  # GET /uberons/1
  # GET /uberons/1.json
  def show
  end

  # GET /uberons/new
  def new
    @uberon = Uberon.new
  end

  # GET /uberons/1/edit
  def edit
  end

  # POST /uberons
  # POST /uberons.json
  def create
    @uberon = Uberon.new(uberon_params)

    respond_to do |format|
      if @uberon.save
        format.html { redirect_to @uberon, notice: 'Uberon was successfully created.' }
        format.json { render action: 'show', status: :created, location: @uberon }
      else
        format.html { render action: 'new' }
        format.json { render json: @uberon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uberons/1
  # PATCH/PUT /uberons/1.json
  def update
    respond_to do |format|
      if @uberon.update(uberon_params)
        format.html { redirect_to @uberon, notice: 'Uberon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @uberon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uberons/1
  # DELETE /uberons/1.json
  def destroy
    @uberon.destroy
    respond_to do |format|
      format.html { redirect_to uberons_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uberon
      @uberon = Uberon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uberon_params
      params.require(:uberon).permit(:name, :accession)
    end
end
