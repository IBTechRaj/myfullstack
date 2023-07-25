module AccountBlock
  class Student < ApplicationRecord
    self.table_name = :students
     has_one_attached :image
     # has_many :courses
     # has_many :language121_classes
	
    has_secure_password
    
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates_presence_of :email
    validates :email, uniqueness: true
    validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "should only contain alphabets" }


    enum membership_notifn: %i[:mn_disabled :mn_checked :mn_unchecked]
    enum booked_cls_notfn:  %i[:bc_disabled :bc_checked :bc_unchecked]
    enum canceled_cls_notifn:%i[:ca_disabled :ca_checked :ca_unchecked]
    enum cls_reminder_notifn: %i[:cr_disabled :cr_checked :cr_unchecked]
    enum cls_change_notifn: %i[:cc_disabled :cc_checked :cc_unchecked]
  
  end
end