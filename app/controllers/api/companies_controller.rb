class Api::CompaniesController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        render json: @user_and_companies, each_serializer: UserAndCompanySerializer, show_gakutika_detail_flag: false, status: :ok
    end


end