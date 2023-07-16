class Student < ApplicationRecord
    self.table_name = :students
	
    has_secure_password
    
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates_presence_of :email
    validates :email, uniqueness: true
    # validates :city, presence: true
    # validates :country, presence: true
    # validates :mobile, presence: true
  end