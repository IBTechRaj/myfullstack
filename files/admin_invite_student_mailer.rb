module AccountBlock
  class AdminInviteStudentMailer < ApplicationMailer
	
      def admin_invite_student(invite_student, host, client_url)
      @invite_student = invite_student
      @host = host
      @client_url = client_url
      token = encoded_token

      stage_url = "https://languageplatformws2022-290480-ruby.b290480.stage.eastus.az.svc.builder.ai"
      dev_url = "https://languageplatformws2022-290480-ruby.b290480.dev.eastus.az.svc.builder.cafe"

      # byebug
      if @client_url == dev_url
        @url = "https://languageplatformws2022-290480-react.b290480.dev.eastus.az.svc.builder.cafe/StudentSignup?token=#{token}"
      elsif @client_url == stage_url

        @url = "https://languageplatformws2022-290480-react.b290480.stage.eastus.az.svc.builder.ai/StudentSignup?token=#{token}"
      else 
       @url = "https://languageplatformws2022-290480-react.b290480.dev.eastus.az.svc.builder.cafe/StudentSignup?token=#{token}"
      end

     
      attachments.inline["lingoamojr.png"] = File.read("#{Rails.root}/app/assets/images/lingoamojr.png")

      mail(
          to: @invite_student.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Account activation') do |format|
        format.html { render 'admin_invite_student' }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @invite_student.id, 60.minutes.from_now
    end
  end
end
