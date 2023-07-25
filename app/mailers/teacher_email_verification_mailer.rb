class TeacherEmailVerificationMailer < ApplicationMailer

  def teacher_email_verification(teacher, host, client_url)
    @teacher = teacher
    @host = host
    @client_url = client_url
    token = encoded_token
    @url = "#{@host}/teachers/activate_account?token=#{token}&client_url=#{@client_url}"
    mail(
        to: @teacher.email,
        from: 'support@groomwell.in',
        subject: 'Account activation') do |format|
      format.html { render 'teacher_email_verification' }
    end
  end

  private

  def encoded_token
    JsonWebToken.encode @teacher.id, 1.days.from_now
  end
end
