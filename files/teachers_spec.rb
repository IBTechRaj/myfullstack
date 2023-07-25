require 'rails_helper'

RSpec.describe AccountBlock::TeachersController, type: :controller do

  T_EMAIL = 'teacher@example.com'
  INV_TOKEN = 'Invalid token'

 
  let(:teacher_params) {{ "first_name": "abc", "last_name": "xyz", "email": T_EMAIL, "password": "A01@pass" } }
  let(:invalid_params) {{ "first_name": "abc", "last_name": "def", "email": "user@example", "password": "useruser"} }
  let(:name_blank_params) {{ "first_name": "", "last_name": "kuk", "email": "user@example", "password": "useruser"} }  

  let(:resend_params) {{"email": "T_EMAIL"}}

  before :context do
    @teacher = FactoryBot.create(:teacher)
    @teacher1 = FactoryBot.create(:teacher) #.merge({email: "sivakumar@gmail.com"})
    @token = BuilderJsonWebToken::JsonWebToken.encode(@teacher.id)
    @token1 = BuilderJsonWebToken::JsonWebToken.encode(@teacher1.id)
  end  

context "when updating notification settings" do
   let(:teacher) {create(:teacher)}
      it "You should  update notification settings" do
        request.headers.merge!(token: @token)
        put :set_notifications, params: {id: teacher.id, teacher: {new_cls_request_notifn: :nc_disabled,
          canceled_cls_notifn: 0,
          cls_reminder_notifn: 1,
          group_cls_notifn: 0,
          ending_group_course_notifn: 0,
          cls_availability_notifn: 2
        }}
        expect(response).to have_http_status(200)
      end 
      it "You should not update notification settings if no reacher" do
        request.headers.merge!(token:@token)
        put :set_notifications, params: {id: -9999, teacher: {new_cls_request_notifn: :nc_disabled,
          canceled_cls_notifn: 0,
          cls_reminder_notifn: 1,
          group_cls_notifn: 0,
          ending_group_course_notifn: 0,
          cls_availability_notifn: 2
        }}
        expect(response).to have_http_status(200)
        # expect(JSON.parse(response.body)['errors']).to include([])
      end 
    end
  
describe "post/create teachers" do
  let(:params) {{ first_name: "abc", last_name: "xyz", email: T_EMAIL, password: "A01@pass" } }
  let(:missing_params) {{ last_name: "xyz", email: T_EMAIL, password: "useruser" } }
  it 'returns success response ' do
    post 'create', params: params
    data = JSON.parse(response.body)
    expect(response).to have_http_status(201)
  end

  it 'returns not_found response ' do
     post 'create', params: missing_params
     data = JSON.parse(response.body)
     expect(response).to have_http_status(422)
  end
end

describe "update teachers profile" do
  it "should allow to update teacher " do
    request.headers.merge!(token: @token)
    put :update,  params: {id: @teacher}
    expect(response.status).to eq 200

  end
end


describe "Get user profile" do
  it "should allow to get profile" do
    request.headers.merge!(token: @token)
    get :index, params: {id: @teacher}
    expect(response.status).to eq 200
  end
end

describe "create teacher profile" do
  it "should not create teacher using invalid email" do
    request.headers.merge!(token: @token)
    post :create, params: teacher_params.merge({'email': 'apsgmail.com'})
    expect(response.status).to eq 422
    expect(JSON.parse(response.body)['errors'][0]['account']).to eq("Email invalid or Already Taken")
  end

  it "should not create teacher when  name blank" do
    request.headers.merge!(token: @token)
    post :create, params: name_blank_params.merge({'name': ''})
    expect(response.status).to eq 422
  end
end

describe "show teacher profile" do
  it "should allow to get teacher profile" do
    request.headers.merge!(token: @token)
    get :show, params: {id: @teacher}
    expect(response.status).to eq 200
  end
end

describe "show teacher profile" do
  it "should not get teacher profile if no teacher" do
    request.headers.merge!(token: @token)
    get :show, params: {id: 1000}
    expect(JSON.parse(response.body)['errors']).to  include('No data exists')
  end
end

describe "edit teacher profile" do
  it "should allow to  edit teacher profile" do
    request.headers.merge!(token: @token)
    get :edit, params: {id: @teacher}
    expect(response.status).to eq 200
  end
end

context 'teacher requests resend email' do
  it 'should resend email' do
    post :create , params: teacher_params
    get :resend_email , params: teacher_params
     # data = JSON.parse(response.body)
     expect(JSON.parse(response.body)['message']).to eq('Email sent again please check')
  # expect(response).to have_http_status(200)
  end
  it 'should not send if teacher not present ' do
    post :create , params: invalid_params
    get :resend_email , params: resend_params
    expect(JSON.parse(response.body)['message']).to eq('No teacher found with this email')
  end
  
 end

describe "Get activate account" do
  before do
    teacher = create(:teacher)
    @token = BuilderJsonWebToken.encode(teacher.id, 1.year.from_now)
  end
  context "when activate account" do
    it "Your Account Is Activated" do
      get :activate_account, params: {token: @token}
      expect(response).to have_http_status(302)
    end 
  end
end

describe "Get account names" do
  before do
    teacher = create(:teacher)
    @token = BuilderJsonWebToken.encode(teacher.id, 1.year.from_now)
  end
  
context "when request names of account" do
    it "You should send names" do
      get :send_names, params: {token: @token}
      expect(response).to have_http_status(200)
    end 
  end

  context "when request teacher profile" do
    it "You should get teacher profile" do
      get :teacher_profile, params: {token: @token}
      expect(response).to have_http_status(200)
    end 
  end

context "when request names of account" do
    it "You should NOT send names" do
      get :send_names, params: {token:1000}
      # expect(response).to have_http_status(400)
       expect(JSON.parse(response.body)['errors']).to include({"token"=>INV_TOKEN})
    end 
  end
end

  describe "Get Deactivate account" do
 
  context "when Deactivate account" do
    it "Your Account Is Deactivated" do
       post :create, params: teacher_params
       put :deactivate_account , params: teacher_params
       expect(JSON.parse(response.body)['message']).to include('Your Account Deactivated')
        # expect(response).to have_http_status(200)
       
    end
  end

  context "when Deactivate account giving wrong email" do
    it "Your Account Is Not Deactivated" do
       post :create , params: teacher_params
        put :deactivate_account, params: {"email": "teacher1@example.com", "password": "password"}
        expect(JSON.parse(response.body)['error']).to eq('Email or Password wrong')
    end
  end
end

  context "when request notification settings" do
    it "You should  send notification settings" do
      get :get_notifications, params: {token: @token}
      expect(response).to have_http_status(200)
    end 
  end
  context "when requesting notification settings" do
    it "You should  not send notification settings" do
      get :get_notifications, params: {token: 1}
     
      expect(JSON.parse(response.body)['errors']).to eq([{"token"=>INV_TOKEN}])
    end 
  end

  context "when request timezone settings" do
    it "You should not send timezone settings" do
      get :get_timezone_date_time_formats, params: {token: 1}
      # TEST passing but code not covered
      expect(response.body).to include(INV_TOKEN)
    end 
  end

   context "when request timezone settings" do
    it "You should  send timezone settings" do
      get :get_timezone_date_time_formats, params: {token: @token}
      expect(response).to have_http_status(200)
    end 
  end

  context "when post timezone settings" do
    it "You should not set timezone settings" do
      post :set_timezone_date_time_formats, params: {token: 1}
      expect(response).to have_http_status(400)
      # expect(JSON.parse(response.body)['error']).to eq('Teacher cannot be found')
    end 
   end

   context "when post timezone settings" do
    it "You should  set timezone settings" do
      post :set_timezone_date_time_formats, params: {token: @token}
      expect(response).to have_http_status(200)
    end 
  end

  context "when display_language to be changed" do
    it "You should  update display_language" do
      request.headers.merge!(token: @token)
      put :set_display_language, params: {display_language: "english"}
      expect(response).to have_http_status(200)
    end 
  end
end

