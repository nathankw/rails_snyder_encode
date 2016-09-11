class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
		@document = Document.find(params[:id])
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
		@document = Document.new(document_params)
		if @document.save
			redirect_to(@document, notice: "Document was successfully created.")
		else
			render(action: :get)
		end
	end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

	def document
		#called by the 'show' view.
		@document = Document.find(params[:id])
		send_data(data=@document.data,options={
							filename: @document.name,
							type: @document.content_type,
							disposition: 'attachment'}
		)
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The document you were looking for could not be found."
      redirect_to documents_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
#      params.require(:document).permit(:name, :description, :content_type, :data, :document_type)
      params.require(:document).permit(:description,:uploaded_document,:document_id)
    end
end