class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :children, dependent: :destroy
  has_many :words, through: :children

  after_create_commit :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
end
