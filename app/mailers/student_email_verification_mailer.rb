class StudentEmailVerificationMailer < ApplicationMailer

  def student_email_verification(student, host, client_url)
    @student = student
    @host = host
    token = encoded_token
    @url = "#{@host}/students/activate_account?token=#{token}&client_url=#{@client_url}"
    mail(
        to: @student.email,
        from: 'support@groomwell.in',
        subject: 'Account activation') do |format|
      format.html { render 'student_email_verification' }
    end
  end

  private

  def encoded_token
    JsonWebToken.encode @student.id, 1.days.from_now
  end
end
