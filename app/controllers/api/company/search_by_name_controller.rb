class Api::Company::SearchByNameController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        @company_names = Company.where('name like ?', "%#{params[:name]}%").pluck(:name)
        render json: { company_names: @company_names }, status: :ok
    end
end
