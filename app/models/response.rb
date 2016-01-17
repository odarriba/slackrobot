class Response
  include Mongoid::Document
  include Mongoid::Timestamps

  field :queries,   type: Array
  field :responses, type: Array
  field :markdown,  type: Boolean, default: false
  field :reply,     type: Boolean, default: false

  validates_presence_of :queries, :responses

  belongs_to :chat
end
