class PlatesController < ApplicationController
	include PlatesConcern #gives me add_wells()
  before_action :set_plate, only: [:show, :edit, :update, :destroy]

  def index
    @plates = policy_scope(Plate).order("lower(name)")
  end

  def show
		authorize @plate
  end

  def new
		authorize Plate
    @plate = Plate.new
  end

  def edit
		authorize @plate
  end

  def create
		authorize Plate
    @plate = Plate.new(plate_params)

		@plate.user = current_user
		create_wells(@plate)

    respond_to do |format|
      if @plate.save
        format.html { redirect_to @plate, notice: 'Plate was successfully created.' }
        format.json { render json: @plate, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @plate.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		authorize @plate
    respond_to do |format|
      if @plate.update(plate_params)
        format.html { redirect_to @plate, notice: 'Plate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @plate.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
		authorize @plate
    @plate.destroy
    respond_to do |format|
      format.html { redirect_to plates_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plate
      @plate = Plate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plate_params
      params.require(:plate).permit(:dimensions, :name, :sequencing_library_prep_kit_id, :paired_end, :vendor_id, :vendor_product_identifier)
    end
end