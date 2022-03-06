class Api::CompaniesController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def search
        @company_names = Company.where('name like ?', "%#{params[:name]}%").pluck(:name)
        render json: { company_names: @company_names }, status: :ok
    end


end