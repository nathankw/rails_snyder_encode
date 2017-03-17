class CloningVectorsController < ApplicationController
  before_action :set_cloning_vector, only: [:show, :edit, :update, :destroy]

  def index
    @cloning_vectors = policy_scope(CloningVector).order("lower(name)")
  end

  def show
		authorize @cloning_vector
  end

  def new
		authorize CloningVector
    @cloning_vector = CloningVector.new
  end

  def edit
		authorize @cloning_vector
  end

  def create
		authorize CloningVector
    @cloning_vector = CloningVector.new(cloning_vector_params)
	
		@cloning_vector.user = current_user	

    respond_to do |format|
      if @cloning_vector.save
        format.html { redirect_to @cloning_vector, notice: 'Cloning vector was successfully created.' }
        format.json { render json: @cloning_vector, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @cloning_vector.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		authorize @cloning_vector
    respond_to do |format|
      if @cloning_vector.update(cloning_vector_params)
        format.html { redirect_to @cloning_vector, notice: 'Cloning vector was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cloning_vector.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
		authorize @cloning_vector
    @cloning_vector.destroy
    respond_to do |format|
      format.html { redirect_to cloning_vectors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cloning_vector
      @cloning_vector = CloningVector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cloning_vector_params
      params.require(:cloning_vector).permit(:name, :description, :url)
    end
end
