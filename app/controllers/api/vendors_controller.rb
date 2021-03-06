class Api::VendorsController < Api::ApplicationController
  #example with curl:
  # curl -H "Authorization: Token token=${token}" http://localhost:3000/api/vendors/3
  before_action :set_vendor, only: [:show, :update, :destroy]

  def find_by
    # find_by defined in ApplicationController#find_by.
    # Use this method when you want to AND all of your query parameters.
    super
  end

  def find_by_or
    # find_by_or defined in ApplicationController#find_by_or.
    # Use this method when you want to OR all of your query parameters.
    super
  end

  def index
    @vendors = policy_scope(Vendor).order("lower(name)")
    render json: @vendors
  end

  def show
    authorize @vendor
    render json: @vendor
  end

  def create
    @vendor = Vendor.new(vendor_params)
    @vendor.user = @current_user
    authorize @vendor
    if @vendor.save
      render json: @vendor, status: 201
    else
      render json: { errors: @vendor.errors.full_messages }, status: 422
    end
  end

  def update
    authorize @vendor
    if @vendor.update(vendor_params)
      render json: @vendor, status: 200
    else
      render json: { errors: @vendor.errors.full_messages }, status: 422
    end
  end

  def destroy
    ddestroy(@vendor)
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(
      :user_id,
      :upstream_identifier,
      :name,
      :notes,
      :description,
      :url
    )
  end
end
