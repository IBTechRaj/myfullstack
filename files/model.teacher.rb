module AccountBlock
  class Teacher < AccountBlock::ApplicationRecord
    self.table_name = :teachers
    has_one_attached :image
    has_many :availabilities
    # has_many :courses

    has_secure_password

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates_presence_of :email
    validates :email, uniqueness: true
    validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "should only contain alphabets" }


    enum new_cls_request_notifn: %i[:nc_disabled :nc_checked :nc_unchecked]
    enum canceled_cls_notifn:%i[:cc_disabled :cc_checked :cc_unchecked]
    enum cls_reminder_notifn: %i[:cr_disabled :cr_checked :cr_unchecked]
    enum group_cls_notifn: %i[:gc_disabled :gc_checked :gc_unchecked]
    enum ending_group_course_notifn: %i[:eg_disabled :eg_checked :eg_unchecked]
    enum cls_availability_notifn: %i[:ca_disabled :ca_checked :ca_unchecked]

  end
end