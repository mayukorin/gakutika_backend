class Api::Gakutika::SearchByTitleController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        @gakutikas = Gakutika.where('title like ?', "%#{params[:title]}%").where(user_id: signin_user(request.headers).id)
        render json: @gakutikas, each_serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :ok
    end
end
