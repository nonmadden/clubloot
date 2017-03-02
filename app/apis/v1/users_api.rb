module V1
  class UsersAPI < Grape::API
    extend Defaults::Engine

    helpers do
      params :token do
        optional :token, type: String, default: nil
      end
      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :users do
      params do
        optional :user_id, type: String, desc: "User Id"
      end
      get '/' do
        begin
          present :status, :success
          present :data, User.all, with: Entities::UserAllExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end

    resource :user do
      resource :contests do
        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          optional :state, type: String, default: "upcoming"
        end
        get "/" do
          begin
            if user = User.find_by(token: params[:token])
              contests = user.contests.find_by(state: params[:state])
              present :status, :success
              present :data, contests, with: Entities::ContestAllExpose
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end

      resource :contest do
        params do
          requires :token,        type: String, default: nil, desc: 'User Token'
          requires :template_id,  type: String, desc: "Template Id"
          requires :details, type: Hash do
            requires :name, type: String
            requires :player, type: Integer
            requires :prize, type: Integer
          end
        end
        post "/new" do
          begin
            template = Template.find(params[:template_id])

            if user = User.find_by(token: params[:token])
              if contest = Contest.create_contest(user, template, params[:details])
                present :status, :success
                present :data, contest #, with: Entities::AuthExpose
              else
                present :status, :failure
                present :data, "Can't creating a new contest."
              end
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end

        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          requires :contest_id, type: String, desc: 'contest_id'
        end
        post "/join" do
          begin
            if user = User.find_by(token: params[:token])
              if user.join_contest(params[:contest_id])
                present :status, :success
                present :data, contest #, with: Entities::AuthExpose
              else
                present :status, :failure
                present :data, "Can't join a contest."
              end
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end

        params do
          requires :token,        type: String, default: nil, desc: 'User Token'
          requires :contest_id,   type: String, desc: "Contest Id"
          requires :details,      type: Array[String], desc: "[{ question: $question_id, answer: $answer_id }]"
        end
        put "/quiz" do
          begin
            if user = User.find_by(token: params[:token])
              if contest = user.contests.find(params[:contest_id])
                if quiz_contest = Contest.quiz(user, contest, params[:details])
                  present :status, :success
                  present :data, quiz_contest #, with: Entities::AuthExpose
                else
                  present :status, :failure
                  present :data, "Can't complete quiz"
                end
              else
                present :status, :failure
                present :data, "Can't found contest"
              end
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end
    end
  end
end
