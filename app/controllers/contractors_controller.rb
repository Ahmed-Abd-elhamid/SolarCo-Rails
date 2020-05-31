class ContractorsController < ApplicationController
  # devise_token_auth_group :member, contains: [:user, :contractor]
  # before_action :authenticate_member!

  # def members_only
  #   render json: {
  #     data: {
  #       message: "Welcome #{current_member.name}",
  #       user: current_member
  #     }
  #   }, status: 200
  # end
  before_action :set_user, only: [:update]

  # PATCH/PUT /contractors/1
  def update
      if @contractor.update(contractor_params)
          render json: @contractor
      else
          render json: @contractor.errors, status: :unprocessable_entity
      end
  end


  # POST /offers
  def create
    @contractor = Contractor.new(offer_params)
    @offer.contractor =  Contractor.find(current_user.id)
    if @offer.save
      render json: @offer, status: :created, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @contractor = Contractor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contractor_params
        params.require(:contractor).permit(:has_office,:address, :avatar)
    end
end
