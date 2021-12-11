module WorksHelper
  def start_time(work)
    if work.start.min > 9
      work.start.hour.to_s+":"+work.start.min.to_s
    else
      work.start.hour.to_s+":0"+work.start.min.to_s
    end
  end

  def finish_time(work)
    if work.finish.min > 9
      work.finish.hour.to_s+":"+work.finish.min.to_s
    else
      work.finish.hour.to_s+":0"+work.finish.min.to_s
    end
  end

  def w_min_cal(work)
    if w_min?
      w_min += work.finish-work.start.div(60)
    else
      w_min = work.finish-work.start.div(60)
    end
  end

  def w_time(w_min)
    w_time_h = w_min.div(60)
    w_time_m = w_min%60
    w_time_h+"時間"+w_time_h+"分"
  end
end
