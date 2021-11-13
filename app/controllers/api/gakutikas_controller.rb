class Api::GakutikasController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler
    def index
        @gakutikas = Gakutika.where(user_id: signin_user(request.headers).id)
        render json: @gakutikas, each_serializer: GakutikaSerializer, status: :ok
    end
    def update_tough_rank
        puts params
        puts "ooooooooooooooooo"
        puts tough_rank_update_params
        tough_rank_update_params.each do |id, new_tough_rank| 
            puts "idは"
            puts id
            gakutika = Gakutika.find(id)
            gakutika.update(tough_rank: new_tough_rank)
        end
        gakutikas = Gakutika.where(user_id: signin_user(request.headers).id)
        render json: gakutikas, each_serializer: GakutikaSerializer, status: :ok
    end
    private
        def tough_rank_update_params
            params.require(:id_and_new_tough_rank)
        end
end
