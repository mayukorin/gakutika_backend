class Api::Gakutika::SearchByTitleController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        @gakutika_titles = Gakutika.where('title like ?', "%#{params[:title]}%").where(user_id: signin_user(request.headers).id).pluck(:title)
        render json: { gakutika_titles: @gakutika_titles }, status: :ok
    end
end
