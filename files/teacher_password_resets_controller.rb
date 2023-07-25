module AccountBlock
  class TeacherPasswordResetsController < ApplicationController

    def forgot
      @email = params[:email].downcase
    	@teacher = Teacher.find_by(email: @email) # if present find user by email
      @client_url = request.headers[:origin] || 'Client Url Missing' #params[:origin]
    	if @teacher
    		TeacherPasswordMailer.teacher_password_reset(@teacher, request.base_url, @client_url).deliver_now
    		render json: {message: 'Password reset link sent'}, status: :ok
    	else
    	    render json: {error: ['Email address not found. Please check and try again.']}
    	end
    end

    def reset
    	token = request.headers[:token] || params[:token]
    	new_password = params[:password]
      password_validator = PasswordValidation.new(new_password)
      return render json: {errors: [
        {account: 'Password not in the required format'},
      ]}, status: :unprocessable_entity if  !password_validator.valid?
    	valid_token = true
    	begin
      	@token = BuilderJsonWebToken.decode(token)
      rescue JWT::ExpiredSignature 
      	valid_token = false
      end
      if valid_token
        @teacher = AccountBlock::Teacher.find_by(id:@token.id)&.update(password: new_password) 
        if @teacher 
          render json: { message: 'Password Reset Successful!'}, status: :ok
    	  end				
    	else
    	  render json: {error: 'Token error'}, status: :not_found
    	end	
    end	
  end
end