class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Define role
  enum role: { admin: 0 }

  # Validate role is admin
  # Validate email is unique
  # Validate email is present
  # Validate password is present
  validates :role, inclusion: { in: roles.keys }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  def admin?
    role == "admin"
  end
end
