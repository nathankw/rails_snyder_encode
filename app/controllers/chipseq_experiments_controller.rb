class ChipseqExperimentsController < ApplicationController
  before_action :set_chipseq_experiment, only: [:show, :edit, :update, :destroy, :add_replicate, :choose_replicates_for_control, :create_control_replicate]
  skip_after_action :verify_authorized, only: [:add_replicate, :choose_replicates_for_control, :create_control_replicate, :get_wt_control_selection]

  def get_wt_control_selection
    starting_biosample = Biosample.find(params["starting_biosample_id"])
    @wild_type_controls = Biosample.wild_type_controls.where(biosample_term_name_id: starting_biosample.biosample_term_name_id)
    @chipseq_experiment = ChipseqExperiment.new
    render layout: false
  end

  def add_replicate
    # AJAX from show view.
    starting_biosample = @chipseq_experiment.starting_biosample
    # Don't include biosamples that are already in self.replicates in the selection.
    @selection = starting_biosample.biosample_parts.where.not(id: @chipseq_experiment.replicates)
    render layout: false
  end

  def choose_replicates_for_control
    @selection = @chipseq_experiment.replicates
    render layout: false
  end

  def create_control_replicate
    replicate_ids = chipseq_experiment_params[:replicate_ids].select{|x| x.present?}
    first_rep = Biosample.find(replicate_ids[0])
    input_cnt = @chipseq_experiment.control_replicates.length + 1
    name = "#{@chipseq_experiment.target.name} #{first_rep.biosample_term_name.name} input #{input_cnt}"
    custom_attrs = {
      part_of_id: nil,
      from_prototype_id: nil,
      pooled_from_biosample_ids: replicate_ids,
      name: name,
      control: true,
      chipseq_experiment_id: @chipseq_experiment.id
    }
    clone = first_rep.clone_biosample(associated_user_id: current_user.id, custom_attrs: custom_attrs)
    flash[:notice] = "Control biosample #{clone.to_label()} was successfully created."
    redirect_to @chipseq_experiment
  end

  def index
    super
  end

  def show
    authorize @chipseq_experiment
  end

  def new
    authorize ChipseqExperiment.new
    @chipseq_experiment = ChipseqExperiment.new
  end

  def edit
    authorize @chipseq_experiment
  end

  def create
    authorize ChipseqExperiment
    #render json: params
    #return
    @chipseq_experiment = ChipseqExperiment.new(chipseq_experiment_params)
    @chipseq_experiment.user = current_user

    respond_to do |format|
      if @chipseq_experiment.save
        format.html { redirect_to @chipseq_experiment, notice: 'Chipseq experiment was successfully created.' }
        format.json { render json: @chipseq_experiment, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @chipseq_experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @chipseq_experiment
    #render json: params
    #return
    respond_to do |format|
      if @chipseq_experiment.update(chipseq_experiment_params)
        format.html { redirect_to @chipseq_experiment, notice: 'Chipseq experiment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chipseq_experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    ddestroy(@chipseq_experiment, redirect_path_success: chipseq_experiments_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chipseq_experiment
      @chipseq_experiment = ChipseqExperiment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chipseq_experiment_params
      params.require(:chipseq_experiment).permit(
        :name,
        :description,
        :notes,
        :submitter_comments,
        :target_id,
        :starting_biosample_id,
        :upstream_identifier,
        :wild_type_control_id,
        :document_ids => [],
        :replicate_ids => [],
        :control_replicate_ids => [],
        documents_attributes: [:id, :_destroy]
      )
    end
end
