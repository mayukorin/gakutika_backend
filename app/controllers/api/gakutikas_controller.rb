class Api::GakutikasController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    before_action :is_gakutika_of_user, only: [:destroy, :update, :show]
    before_action :is_gakutikas_of_user, only: [:update_tough_rank]

    def index
        @gakutikas = Gakutika.eager_loading.where(user_id: signin_user(request.headers).id)
        render json: @gakutikas, each_serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :ok
    end
    def update_tough_rank
        
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
            render json: { message: @gakutika.errors.full_messages }, status: :bad_request
        end
    end

    def show
        puts @gakutika
        render json: @gakutika, serializer: GakutikaSerializer, include: [:questions, user_and_companies: [:company, user_and_company_and_gakutikas: [:gakutika, :questions] ]], show_gakutika_detail_flag: true, user_id: signin_user(request.headers).id, gakutika_id: @gakutika.id, status: :ok
    end

    def update
        
        if @gakutika.update(gakutika_params_for_save) 
            render json: @gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: false, status: :accepted
        else
            render json: { message: @gakutika.errors.full_messages }, status: :bad_request
        end
    end

    def destroy
        tough_rank = @gakutika.tough_rank
        @gakutika.destroy
        under_tough_rank_gakutikas = signin_user(request.headers).gakutikas.where("tough_rank > ?", tough_rank)
        under_tough_rank_gakutikas.map {|gakutika|
            gakutika.tough_rank = gakutika.tough_rank-1;
            gakutika.save
        }
        render status: :no_content
    end
    
    private
        def tough_rank_update_params
            params.require(:id_and_new_tough_rank)
        end
        def gakutika_params_for_save
            gakutika_params_for_save = gakutika_params.to_h
            gakutika_params_for_save[:start_month] = gakutika_params[:start_month] + "-1" unless gakutika_params[:start_month].nil?
            gakutika_params_for_save[:end_month] = gakutika_params[:end_month] + "-1" unless gakutika_params[:end_month].nil?
            gakutika_params_for_save[:tough_rank] = signin_user(request.headers).gakutikas.count + 1 if gakutika_params_for_save[:tough_rank] == "0" and @gakutika.nil? # update ではない時
            
            return gakutika_params_for_save
        end
        def gakutika_params
            params.require(:gakutika).permit(:title, :content, :start_month, :end_month, :tough_rank)
        end
        def is_gakutika_of_user
            # @gakutika = signin_user(request.headers).gakutikas.eager_load(companies: :user_and_companies, questions: :company, user_and_company_and_gakutikas: :company).find_by(id: params[:id])
            # @gakutika = signin_user(request.headers).gakutikas.eager_load(:user_and_company_and_gakutikas, user_and_companies: [:company, user_and_company_and_gakutikas: :gakutika], questions: :company).find_by(id: params[:id])
            # @gakutika = signin_user(request.headers).gakutikas.eager_loading
            
            @gakutika = signin_user(request.headers).gakutikas.eager_loading.find_by(id: params[:id])
            render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request if @gakutika.nil?
        end
        def is_gakutikas_of_user
            gakutika_cnt = signin_user(request.headers).gakutikas.count
            tough_rank_update_params.each do |id, new_tough_rank| 
                gakutika = Gakutika.find_by(id: id)
                render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request if gakutika.nil?
                gakutika.update(tough_rank: gakutika_cnt+id.to_i)
            end
        end
end
