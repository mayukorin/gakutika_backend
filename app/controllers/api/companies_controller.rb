class Api::CompaniessController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        @companies = signin_user(request.headers).companies.includes(:gakutika)
        render json: @companies, each_serializer: CompanySerializer, show_gakutika_detail_flag: false, status: :ok
    end


end