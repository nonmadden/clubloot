class Program
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  has_many :templates

  field :name,      type: String
  field :category,  type: String
  field :active,    type: Boolean, default: false

  has_mongoid_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }

  scope :active,    -> { where(active: true) }
  scope :pending,   -> { where(active: false) }

  validates :name, :category, :attachment, presence: true

  def self.upcoming
    self.active.includes(:templates).select do |program|
      program.templates.upcoming_program.present?
    end
  end

  def self.live
    self.active.includes(:templates).select do |program|
      program.templates.live_program.present?
    end
  end

  def self.past
    self.active.includes(:templates).select do |program|
      program.templates.past_program.present?
    end
  end

  def upcoming_time
    templates.upcoming_time
  end

  def all_contests
    # templates.current_template.contests
    templates.sort_by(&:end_time).each do |template|
      template.contests
    end
  end
end
