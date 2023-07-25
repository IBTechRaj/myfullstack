module AccountBlock
  class InviteeTeachersController < ApplicationController
	def activate_account
      token = params[:token]
      @client_url = params[:client_url]
      @token = BuilderJsonWebToken.decode(token)
      @teacher = AccountBlock::InviteeTeacher.find_by(id:@token.id).update(activated: true)
      redirect_to "#{@client_url}/TeacherEmailVerified?token=#{token}"
    end

    def deactivate_account
      @email = params[:email]
      @teacher = AccountBlock::InviteeTeacher.find_by(email: @email)
      if @teacher && @teacher.authenticate(params[:password]) 
        @teacher.update(activated: false)
        render json: {message: 'Your Account Deactivated'}, status: :ok
      else
        render json: { error: 'Email or Password wrong'}
      end
    end

    def send_invitee_names
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @invitee_teacher = AccountBlock::InviteeTeacher.find_by(id: @token.id)
      if @invitee_teacher
        render json: { id: @invitee_teacher.id, email: @invitee_teacher.email, first_name: @invitee_teacher.first_name, last_name: @invitee_teacher.last_name}
     
      end
    end
  end
end