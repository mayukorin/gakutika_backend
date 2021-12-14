class Api::CompaniesController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        # @companies = signin_user(request.headers).companies
        # render json: @companies, each_serializer: CompanySerializer, show_gakutika_detail_flag: false, user_id: signin_user(request.headers).id, status: :ok
        @user_and_companies = signin_user(request.headers).user_and_companies
        render json: @user_and_companies, each_serializer: UserAndCompanySerializer, show_gakutika_detail_flag: false, status: :ok
    end


end