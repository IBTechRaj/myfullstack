module BxBlockPassword
  class StudentPasswordsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def change_password
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      password_validator = AccountBlock::PasswordValidation.new(params[:new_password])
      return render json: {errors: [
        {account: 'Password not in the required format'},
      ]}, status: :unprocessable_entity if  !password_validator.valid?
      if @student && @student.authenticate(params[:old_password])
        @student.update(password: params[:new_password])
        render json: { message: 'Password updated successfully'}, status: :created
      else
        render json: { error: 'Email or password wrong'}, status: :unprocessable_entity
      end
    end

  end
end
