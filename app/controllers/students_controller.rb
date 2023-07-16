  class StudentsController < ApplicationController
    before_action :set_student, only: [:edit, :update]

    def create
      query_email = student_params['email'].downcase
      account = Student.where('LOWER(email) = ?', query_email).first

      validator = EmailValidation.new(student_params['email'])

      return render json: {errors: [
        {account: 'Email invalid or Already Taken'},
      ]}, status: :unprocessable_entity if account || !validator.valid?

      @student = Student.new(student_params)
      @client_url = request.headers[:origin] || 'Client Url Missing' 
      @student = Student.new(student_params)
      if @student.save
        StudentEmailVerificationMailer.student_email_verification(@student, request.base_url, @client_url).deliver_now!
        render json: StudentSerializer.new(@student, meta: {
          token: encode(@student.id),
        }).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@student.errors)},
          status: :unprocessable_entity
      end
    end
    
    def activate_account
      token = params[:token]
      @token = JsonWebToken.decode(token)
      @student = Student.find_by(id:@token.id).update(activated: true)
      render json: {message: 'Email Verification Successful!'}, status: :ok
    end

    def resend_email
      @email = params[:email]
      @student = Student.find_by(email: @email)
      if @student
        StudentEmailValidationMailer.student_email_validation(@student, request.base_url).deliver_now!
          render json: {message: 'Email sent again please check'}, status: :ok
        else
          render json: { message: 'No student found with this email'}
      end
    end

    def update
      if @student.update(student_params)
       render json: StudentSerializer.new(@student, meta: {message: 'Students Profile Updated Successfully.'
        }).serializable_hash, status: 200
      else
        render json: {errors: format_activerecord_errors(@student.errors), status: 422},
        status: :unprocessable_entity
      end
    end

    def index
      @student = Student.all
      if @student.present?
        render json: StudentSerializer.new(@student, meta: {
        message: "List of Students."}).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'No Students found.'},]}, status: :ok
      end
    end

    def edit
      render json: @student
    end

    def show
      @student = Student.find_by(id: params[:id])
      if @student.blank?
         render json: {errors: 'No data exists', status: 422}, status: 422
      else
         render json: StudentSerializer.new(@student).serializable_hash, status: 200
      end
    end
    
    private

    def encode(id)
      JsonWebToken.encode id
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def student_params
      params.permit(:first_name, :last_name, :email, :password, :confirmation_password)
    end

    def set_student
      @student = Student.find(params[:id])
    end
#..................................................
    def set_access_token
    self.access_token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)

      break token unless User.where(access_token: token).exists?
    end
  end
  end
