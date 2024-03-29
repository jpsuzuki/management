class WorkingButtonsController < ApplicationController

  def start
    if work = current_user.works.create(work_start)
      # work idを追加する記述
      @current_user.update(add_working(work))
      flash[:success] = "出勤しました"
      redirect_to root_path
    end
  end

  def finish
    if current_user.working?
      Work.find(@current_user.working).update(work_finish)
      @current_user.update(remove_working)
      flash[:success] = "退勤しました"
      redirect_to root_path
    end
  end

  private
    def work_start
      now = Time.at(Time.current.to_i/60*60)
      { day: Date.current, start: now }
    end

    def add_working(work)
      { working: work.id }
    end

    def work_finish
      now = Time.at(Time.current.to_i/60*60)
      { finish: now }
    end

    def remove_working
      { working: nil}
    end
end