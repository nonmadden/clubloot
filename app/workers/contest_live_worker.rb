class ContestLiveWorker
  include Sidekiq::Worker

  def perform(*args)
    current_time = Time.zone.now

    Contest.where(_state: :upcoming).includes(:template).each do |contest|
      start_time  = contest.template.start_time
      end_time    = contest.template.end_time

      if current_time >= end_time
        if contest.players.count < contest.max_players
          contest.update(_state: :cancel, active: false, _status: :unusable)
        else
          contest.update(_state: :live, active: false)
        end
      end
    end
  end
end
