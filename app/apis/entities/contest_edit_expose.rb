class Entities::ContestEditExpose < Grape::Entity
  expose :id
  expose :name
  expose :quizes
  # expose :template do |item|
  #   item.template
  # end
end
