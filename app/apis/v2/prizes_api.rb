module V2
  class PrizesAPI < Grape::API

    resource :prizes do
      get '/' do
        begin
          prizes = Prize.all.select{|prize| !prize.out_of_stock? }
          if prizes
            present :status, :success
            if prizes.present?
              present :data, prizes, with: Entities::V2::PrizesExpose
            else
              present :data, prizes
            end
          else
            present :status, :failure
            present :data, "Can't show data"
          end
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
