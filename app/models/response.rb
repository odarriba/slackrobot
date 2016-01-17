class Response
  include Mongoid::Document
  include Mongoid::Timestamp

  field :queries,   type: Array
  field :responses, type: Array
  field :markdown,  type: Boolean
  field :reply,     type: Boolean

  validates_presence_of :queries, :responses

  belongs_to :chat
end
