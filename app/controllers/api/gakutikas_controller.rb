class Api::GakutikasController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    before_action :correct_user, only: [:destroy, :update]

    def index
        @gakutikas = Gakutika.where(user_id: signin_user(request.headers).id)
        render json: @gakutikas, each_serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :ok
    end
    def update_tough_rank
        
        gakutika_cnt = signin_user(request.headers).gakutikas.count
        
        tough_rank_update_params.each do |id, new_tough_rank| 
            gakutika = Gakutika.find(id)
            gakutika.update(tough_rank: gakutika_cnt+id.to_i)
        end

        tough_rank_update_params.each do |id, new_tough_rank| 
            gakutika = Gakutika.find(id)
            gakutika.update(tough_rank: new_tough_rank)
        end
        gakutikas = Gakutika.where(user_id: signin_user(request.headers).id)
        render json: gakutikas, each_serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :ok
    end
    def create
        @gakutika = signin_user(request.headers).gakutikas.build(gakutika_params_for_save)
        if @gakutika.save  
            render json: @gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :created
        else
            render json: @gakutika.errors, status: :bad_request
        end
    end

    def show
        @gakutika = Gakutika.eager_load(:questions, questions: :company).find(params[:id])
        render json: @gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: true, status: :ok
    end

    def update
        
        if @gakutika.update(gakutika_params_for_save) 
            render json: @gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :accepted
        else
            render json: @gakutika.errors, status: :bad_request
        end
    end

    def destroy
        @question.destroy
        render status: :no_content
    end
    
    private
        def tough_rank_update_params
            params.require(:id_and_new_tough_rank)
        end
        def gakutika_params_for_save
            gakutika_params_for_save = gakutika_params.to_h
            gakutika_params_for_save[:start_month] = Date.strptime(gakutika_params[:start_month], '%Y-%m')
            gakutika_params_for_save[:end_month] = Date.strptime(gakutika_params[:end_month], '%Y-%m')
            gakutika_params_for_save[:tough_rank] = signin_user(request.headers).gakutikas.count + 1 if gakutika_params_for_save[:tough_rank] == "0"
            return gakutika_params_for_save
        end
        def gakutika_params
            params.require(:gakutika).permit(:title, :content, :start_month, :end_month, :tough_rank)
        end
        def correct_user
            @gakutika = signin_user(request.headers).gakutikas.find(params[:id])
            render json: { message: ['不正なアクセスです'] }, status: :bad_request if @gakutika.nil?
        end
end
