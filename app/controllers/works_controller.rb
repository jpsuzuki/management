class WorksController < ApplicationController
    before_action :logged_in_user, only:[:index,:new,:edit,
                                        :create,:update,:destroy]
    def index
    end

    def new
        @work = current_user.works.build if logged_in?
    end

    def edit
    end

    def create
        @work = current_user.works.build(work_params)
        if @work.save
            flash[:success] = "勤怠情報を作りました"
            redirect_to current_user
        else
            render 'new'
        end
    end

    def update
    end

    def destroy
    end

    private
        def work_params
            params.require(:work).parmit(:day,:start,:finish)
        end
end
