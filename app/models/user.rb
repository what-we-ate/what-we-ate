class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable #, :omniauthable

  has_one :profile
  validates :first_name, :last_name, presence: true
end
