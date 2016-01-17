class Chat
  include Mongoid::Document
  include Mongoid::Timestamp

  field :telegram_id, type: Integer
  field :name, type: String

  has_many :responses

  validates_presence_of :telegram_id, :name
  validates_uniqueness_of :telegram_id
end
