class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  has_one :contact, dependent: :destroy
  has_many :jobs, dependent: :destroy
  
  accepts_nested_attributes_for :contact
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :contact_attributes, :type
  
end
