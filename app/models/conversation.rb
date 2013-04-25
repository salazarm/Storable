class Conversation < ActiveRecord::Base
  attr_accessible :host_id, :renter_id
  belongs_to :listing

  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"

  has_many :messages

  def as_json(options={})
      super(:include =>[:messages])
  end
end