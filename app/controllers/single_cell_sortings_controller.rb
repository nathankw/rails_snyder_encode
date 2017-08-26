class SingleCellSortingsController < ApplicationController
  before_action :set_single_cell_sorting, only: [:show, :edit, :update, :destroy, :add_sorting_biosample, :add_plate, :add_library_prototype]
	skip_after_action :verify_authorized, only: [:add_sorting_biosample, :add_plate, :add_library_prototype]

	def add_library_prototype
		#non AJAX
		custom_lib_params = {
			name: "#{@single_cell_sorting.name} library prototype",
			prototype: true, 
			biosample_id: @single_cell_sorting.sorting_biosample_id
		}
		@library = @single_cell_sorting.build_library_prototype(custom_lib_params)
		flash[:action] = :add_library_prototype
	end

	def add_plate
		#called via AJAX
		@plate = @single_cell_sorting.plates.build
		#Needed to set @plate above since that is used in the partial single_cell_sortings/_add_plate.html.erb that renders a Plate form. -->
		render partial: "add_plate", layout: false
		flash[:action] = "show"
	end

  def add_sorting_biosample
		#called via AJAX
    sorting_biosample = @single_cell_sorting.starting_biosample.dup
		sorting_biosample.encid = nil
    sorting_biosample.parent_biosample =  @single_cell_sorting.starting_biosample
		sorting_biosample.prototype = true
    sorting_biosample.name =  @single_cell_sorting.name + " " + "biosample prototype"
    @biosample = sorting_biosample
		#Needed to set @biosample above since that is used in the partial single_cell_sortings/_add_sorting_biosample.html.erb that renders a Biosample form. -->
    render partial: "add_sorting_biosample", layout: false
		flash[:action] = "show"
  end 

  def index
    @single_cell_sortings = policy_scope(SingleCellSorting)
  end

  def show
		authorize @single_cell_sorting
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @single_cell_sorting }
    end
  end

  def new
		authorize SingleCellSorting
    @single_cell_sorting = SingleCellSorting.new
  end

  def edit
		authorize @single_cell_sorting
  end

  def create
		authorize SingleCellSorting
    @single_cell_sorting = SingleCellSorting.new(single_cell_sorting_params)
		@single_cell_sorting.user = current_user

    respond_to do |format|
      if @single_cell_sorting.save
        format.html { redirect_to @single_cell_sorting, notice: 'Single cell sorting was successfully created.' }
        format.json { render json: @single_cell_sorting, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @single_cell_sorting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		authorize @single_cell_sorting
		scs_params = single_cell_sorting_params

		if scs_params[:library_prototype_attributes].present? and scs_params[:library_prototype_attributes][:id].blank?
			#Then user is adding the library_prototype.
			scs_params[:library_prototype_attributes][:user_id] = current_user.id
		end

		if scs_params[:sorting_biosample_attributes].present? and scs_params[:sorting_biosample_attributes][:id].blank?
			#Then user is adding the sorting biosample. 
			scs_params[:sorting_biosample_attributes][:user_id] = current_user.id
		end
		if scs_params[:plates_attributes].present?
			scs_params[:plates_attributes].each do |pos,plate_params| #keys are integers, like indices in a list.
				next if plate_params.include?(:id) #Because the user is updating a plate
				scs_params[:plates_attributes][pos][:user_id] = current_user.id
			end
		end
    respond_to do |format|
			begin
				res = @single_cell_sorting.update(scs_params)
			rescue RuntimeError => e
				res = false
				flash[:alert] = e.message
			end
      if res
        format.html { redirect_to @single_cell_sorting, notice: 'Single cell sorting was successfully updated.' }
        format.json { head :no_content }
      else
				action = flash[:action]
				if action.present?
					#set again for next request.
					flash[:action] = action
				end
        format.html { render flash[:action] || 'edit' } 
        #format.html { render json: @single_cell_sorting.errors }
        #format.html { render json: @single_cell_sorting.errors }
        format.json { render json: @single_cell_sorting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
		authorize @single_cell_sorting
    @single_cell_sorting.destroy
    respond_to do |format|
      format.html { redirect_to single_cell_sortings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_single_cell_sorting
      @single_cell_sorting = SingleCellSorting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def single_cell_sorting_params
			params.require(:single_cell_sorting).permit(:starting_biosample_id, :sorting_biosample_id, :name, :description, :library_prototype_id, library_prototype_attributes: [:prototype, :paired_end, :sequencing_library_prep_kit_id, :library_fragmentation_method_id, :concentration, :concentration_unit_id, :is_control, :nucleic_acid_term_id, :biosample_id, :vendor_id, :lot_identifier, :vendor_product_identifier, :size_range, :strand_specific, :name, :document_ids => []], sorting_biosample_attributes: [:prototype, :parent_biosample_id, :control, :biosample_term_name_id, :submitter_comments, :lot_identifier, :vendor_product_identifier, :description, :passage_number, :culture_harvest_date, :encid, :donor_id,:vendor_id,:biosample_type_id,:name, :document_ids => [], documents_attributes: [:id,:_destroy]], plates_attributes: [:starting_biosample_id, :dimensions, :name, :vendor_id, :vendor_product_identifier])
    end
end
