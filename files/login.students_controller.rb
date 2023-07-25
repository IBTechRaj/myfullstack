module BxBlockLogin
  class StudentsController < ApplicationController
        
    def create
      query_email = params['email'].downcase
      student = AccountBlock::Student.find_by_email(query_email)
      if student
        if student.activated == false
          if student.uniq_id != nil
            render json: {message: 'Your Account is deactivated'}, status: :unprocessable_entity
          else
            render json: {message: 'Your Account is not activated'}, status: :unprocessable_entity
          end
        else
          if student.authenticate(params[:password])
           
            render json: AccountBlock::StudentSerializer.new(student, meta: {
              token: encode(student.id),
            }).serializable_hash, status: :created
          else
            render json: { message: 'Invalid email or password'}, status: :unprocessable_entity
          end
        end
      else
        render json: { message: 'Invalid email or password'}, status: :unprocessable_entity
      end
    end   
    
    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end
  end
end