class Api::GakutikasController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler
    def index
        @gakutikas = Gakutika.where(user_id: signin_user(request.headers).id)
        render json: @gakutikas, each_serializer: GakutikaSerializer, status: :ok
    end
end
