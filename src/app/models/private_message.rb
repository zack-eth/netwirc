class PrivateMessage < ActiveRecord::Base
  has_many :users
end