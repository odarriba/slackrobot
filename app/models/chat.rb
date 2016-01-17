class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :telegram_id, type: Integer
  field :title,       type: String
  field :is_group,    type: Boolean, default: true

  has_many :responses

  validates_presence_of :telegram_id, :title
  validates_uniqueness_of :telegram_id
end
