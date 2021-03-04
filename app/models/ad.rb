class Ad < ActiveRecord::Base
  validates :title, :description, :city, :user_id, presence: true
end