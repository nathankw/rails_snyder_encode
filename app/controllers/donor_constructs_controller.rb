class DonorConstructsController < ApplicationController
  before_action :set_donor_construct, only: [:show, :edit, :update, :destroy]
	skip_after_action :verify_authorized, only: [:select_construct_tag]

	def select_construct_tag
    @donor_construct = DonorConstruct.new
    exclude_construct_tags = params[:exclude_construct_tags]
    if exclude_construct_tags.present?
      if exclude_construct_tags.is_a?(String)
        exclude_construct_tags = Array(exclude_construct_tags)
      end 
			@construct_tags = ConstructTag.where.not(id: [exclude_construct_tags])	
		else
			@construct_tags = ConstructTag.all
    end 
    
    render layout: false
  end	

  def index
    @records = policy_scope(DonorConstruct).order("lower(name)").page params[:page]
  end

  def show
		authorize @donor_construct
  end

  def new
		authorize DonorConstruct
    @donor_construct = DonorConstruct.new
  end

  def edit
		authorize @donor_construct
  end

  def create
		authorize DonorConstruct
    @donor_construct = DonorConstruct.new(donor_construct_params)

		@donor_construct.user = current_user

    respond_to do |format|
      if @donor_construct.save
        format.html { redirect_to @donor_construct, notice: 'Donor construct was successfully created.' }
        format.json { render json: @donor_construct, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @donor_construct.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
		authorize @donor_construct
    respond_to do |format|
      if @donor_construct.update(donor_construct_params)
        format.html { redirect_to @donor_construct, notice: 'Donor construct was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @donor_construct.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
		authorize @donor_construct
		ddestroy(@donor_construct,donor_constructs_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donor_construct
      @donor_construct = set_record(controller_name,params[:id]) #set_record defined in application_controller.rb
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donor_construct_params
      params.require(:donor_construct).permit(:refseq_transcript, :ensembl_transcript, :primer_left_forward, :primer_left_reverse, :primer_right_forward, :primer_right_reverse, :addgene_id, :name, :cloning_vector_id, :vendor_id, :vendor_product_identifier, :target_id, :description, :insert_sequence, :construct_tag_ids => [], construct_tags_attributes: [:id,:_destroy] )
    end
end
