module UsersHelper

  def work_date(work)
    if !!work
      work.day.month.to_s+"/"+work.day.day.to_s
    end
  end

  def start_time(work)
    if work.start.min > 9
      work.start.hour.to_s+":"+work.start.min.to_s
    else
      work.start.hour.to_s+":0"+work.start.min.to_s
    end
  end

  def finish_time(work)
    if !!work.finish
      if work.finish.min > 9
        work.finish.hour.to_s+":"+work.finish.min.to_s
      else
        work.finish.hour.to_s+":0"+work.finish.min.to_s
      end
    else
      "未退勤"
    end
  end

  # def all_working(works)
  #   working = 0
  #   works.each do |work|
  #     working += work.finish.to_i-work.start.to_i
  #   end
  #   min = working.div(60)%60
  #   hour = working.div(60).div(60)
  # end



  # def w_min_cal(work)
  #   if @w_min?
  #     @w_min += work.finish-work.start.div(60)
  #   else
  #     @w_min = work.finish-work.start.div(60)
  #   end
  # end

  # def w_time
  #   w_time_h = @w_min.div(60)
  #   w_time_m = @w_min%60
  #   w_time_h.to_s+"時間"+w_time_h.to_s+"分"
  # end

end
