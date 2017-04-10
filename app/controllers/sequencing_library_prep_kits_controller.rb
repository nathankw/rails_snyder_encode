class SequencingLibraryPrepKitsController < ApplicationController
	include DocumentsConcern #gives me add_documents()
  before_action :set_sequencing_library_prep_kit, only: [:show, :edit, :update, :destroy]

  def index
    @sequencing_library_prep_kits = policy_scope(SequencingLibraryPrepKit.order("lower(name)"))
  end

  def show
		authorize @sequencing_library_prep_kit
  end

  def new
		authorize SequencingLibraryPrepKit
    @sequencing_library_prep_kit = SequencingLibraryPrepKit.new
  end

  def edit
		authorize @sequencing_library_prep_kit
  end

  def create
		authorize SequencingLibraryPrepKit
    @sequencing_library_prep_kit = SequencingLibraryPrepKit.new(sequencing_library_prep_kit_params)
		@sequencing_library_prep_kit.user = current_user

		@sequencing_library_prep_kit = add_documents(@sequencing_library_prep_kit,params[:sequencing_library_prep_kit][:document_ids])
    respond_to do |format|
      if @sequencing_library_prep_kit.save
        format.html { redirect_to @sequencing_library_prep_kit, notice: 'Sequencing library prep kit was successfully created.' }
        format.json { render json: @sequencing_library_prep_kit, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @sequencing_library_prep_kit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		authorize @sequencing_library_prep_kit
		@sequencing_library_prep_kit = add_documents(@sequencing_library_prep_kit,params[:sequencing_library_prep_kit][:document_ids])

    respond_to do |format|
      if @sequencing_library_prep_kit.update(sequencing_library_prep_kit_params)
        format.html { redirect_to @sequencing_library_prep_kit, notice: 'Sequencing library prep kit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sequencing_library_prep_kit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequencing_library_prep_kits/1
  # DELETE /sequencing_library_prep_kits/1.json
  def destroy
		authorize @sequencing_library_prep_kit
    @sequencing_library_prep_kit.destroy
    respond_to do |format|
      format.html { redirect_to sequencing_library_prep_kits_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sequencing_library_prep_kit
      @sequencing_library_prep_kit = SequencingLibraryPrepKit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sequencing_library_prep_kit_params
      params.require(:sequencing_library_prep_kit).permit(:user_id, :name, :vendor_id, :description, documents_attributes: [:id,:_destroy])
    end
end