require 'rails_helper'

RSpec.describe AccountBlock::Teacher, type: :model do

  before(:all) do
    @teacher1 = create(:teacher)
  end
  
  it "is valid with valid attributes" do
    expect(@teacher1).to be_valid
  end
  
  it "has a unique email" do
     teacher2 = create(:teacher, email: "dennis@gmail.com")
    teacher2 = build(:teacher, email: "dennis@gmail.com")
    expect(teacher2).to_not be_valid
  end
  
  it "is not valid without a password" do 
    teacher2 = build(:teacher, password: nil)
    expect(teacher2).to_not be_valid
  end
  
  it "is not valid without a firstname" do 
    teacher2 = build(:teacher, first_name: nil)
    expect(teacher2).to_not be_valid
  end
  
  it "is not valid without a lastname" do 
    teacher2 = build(:teacher, last_name: nil)
    expect(teacher2).to_not be_valid
  end
  
  it "is not valid without an email" do
    teacher2 = build(:teacher, email: nil)
    expect(teacher2).to_not be_valid
  end
  
  it "is valid with new_cls_request_notifn zero" do
    teacher2 = build(:teacher, new_cls_request_notifn: 0)
    expect(teacher2).to be_valid
  end

it "is valid with canceled_cls_notifn zero" do
    teacher2 = build(:teacher, canceled_cls_notifn: 1)
    expect(teacher2).to be_valid
  end

it "is valid with cls_reminder_notifn zero" do
    teacher2 = build(:teacher, cls_reminder_notifn: 2)
    expect(teacher2).to be_valid
  end

it "is valid with group_cls_notifn zero" do
    teacher2 = build(:teacher, group_cls_notifn: 0)
    expect(teacher2).to be_valid
  end

it "is valid with ending_group_course_notifn zero" do
    teacher2 = build(:teacher, ending_group_course_notifn: 1)
    expect(teacher2).to be_valid
  end

it "is valid with cls_availability_notifn zero" do
    teacher2 = build(:teacher, cls_availability_notifn: 2)
    expect(teacher2).to be_valid
  end

end

