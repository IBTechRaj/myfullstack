module AccountBlock
  class StudentEmailValidationMailer < ApplicationMailer

    def student_email_validation(student, host, client_url)
      @student = student
      @host = host
      @client_url = client_url
      token = encoded_token
      @url = "#{@host}/account_block/students/activate_account?token=#{token}&client_url=#{@client_url}"
      attachments.inline["lingoamojr.png"] = File.read("#{Rails.root}/app/assets/images/lingoamojr.png")
      mail(
          to: @student.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Account activation') do |format|
        format.html { render 'student_email_validation' }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @student.id, 10.minutes.from_now
    end
  end
end