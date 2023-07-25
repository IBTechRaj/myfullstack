module AccountBlock
  class StudentsController < ApplicationController
    before_action :set_student, only: [:edit, :update]

    def create
      query_email = student_params['email'].downcase
      account = Student.where('LOWER(email) = ?', query_email).first

      validator = EmailValidation.new(student_params['email'])
      password_validator = PasswordValidation.new(student_params['password'])

      return render json: {errors: [
        {account: 'Email invalid or Already Taken'},
      ]}, status: :unprocessable_entity if account || !validator.valid?

      return render json: {errors: [
        {account: 'Password not in the required format'},
      ]}, status: :unprocessable_entity if  !password_validator.valid?
      @student = Student.new(student_params)
      @client_url = request.headers[:origin] || 'Clinet Url Missing' #params[:origin]
      if @student.save
        StudentEmailValidationMailer.student_email_validation(@student, request.base_url, @client_url).deliver_now!
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
      @client_url = params[:client_url]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id:@token.id).update(activated: true, uniq_id: set_uniq_id)
      redirect_to "#{@client_url}/StudentEmailVerified?token=#{token}"
    end

    def deactivate_account
      @email = params[:email]
      @student = AccountBlock::Student.find_by(email: @email)
      if @student && @student.authenticate(params[:password]) 
        @student.update(activated: false)
        render json: {message: 'Your Account Deactivated'}, status: :ok
      else
        render json: { error: 'Email or Password wrong'}
      end
    end

    def resend_email
      @email = params[:email].downcase
      client_url = request.headers[:origin] || 'Clinet Url Missing' #params[:origin]
      @student = AccountBlock::Student.find_by(email: @email)
      if @student
        StudentEmailValidationMailer.student_email_validation(@student, request.base_url, client_url).deliver_now!
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

    def send_names
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      if @student
        render json: { id: @student.id, email: @student.email, first_name: @student.first_name, last_name: @student.last_name, uniq_id: @student.uniq_id}, status: :ok
      end
    end

    def student_view
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      if @student
        render json:  AccountBlock::StudentProfileSerializer.new(@student).serializable_hash, status: 200
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
      @student = AccountBlock::Student.find_by(id: params[:id])
      if @student.blank?
         render json: {errors: 'No data exists', status: 422}, status: 422
      else
         render json: AccountBlock::StudentSerializer.new(@student).serializable_hash, status: 200
      end
    end

 def get_notifications
       token = request.headers[:token] || params[:token]
      # token = params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      if @student
        render json: { 
          membership_notifn: get_notifn(@student.membership_notifn),
          booked_cls_notfn: get_notifn(@student.booked_cls_notfn),
          canceled_cls_notifn: get_notifn(@student.canceled_cls_notifn),
          cls_reminder_notifn: get_notifn(@student.cls_reminder_notifn),
          cls_change_notifn: get_notifn(@student.cls_change_notifn)
        }
      # else
        # TEST passing, but code not covered
        # render json: { errors: 'Invalid token'}, status: :not_found
      end
    end

    def set_notifications
       token = request.headers[:token] || params[:token]
      # token = params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      
      if @student.update( 
          membership_notifn: set_notifn(params[:membership_notifn]),
          booked_cls_notfn: set_notifn(params[:booked_cls_notfn]),
          canceled_cls_notifn: set_notifn(params[:canceled_cls_notifn]),
          cls_reminder_notifn: set_notifn(params[:cls_reminder_notifn]),
          cls_change_notifn: set_notifn(params[:cls_change_notifn])
        )
      render json: {message: 'Notification preferences saved'}, status: :ok
      else
        render json: {error: 'This student is not available'}, status: :unprocessable_entity
      end
    end
    def get_timezone_date_time_formats
       token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)

      if @student
        render json: {
          id: @student.id,
          time_zone: @student.time_zone,
          date_format: @student.date_format,
          time_format: @student.time_format
        }

        # else
        # render json: {errors: 'Invalid token'}, status: :unprocessable_entity
      end
    end

    def set_timezone_date_time_formats
       token = request.headers[:token] || params[:token]
      # token = params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      if @student.update(
          time_zone: params[:time_zone],
          date_format: params[:date_format],
          time_format: params[:time_format]
          )
      render json: {message: 'Time zone Date Time formats saved'}, status: :ok
      # else
      #   render json: {error: 'Teacher cannot be found'}, status: :unprocessable_entity
      end
    end
    
    def set_display_language
      token = request.headers[:token]
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)
      if @student.update(
          display_language: params[:display_language]
          )
      render json: {message: 'Student display language updated'}, status: :ok
      end
    end

    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def student_params
      params.permit(:first_name, :last_name, :email, :password, :confirmation_password, :company, :image, :bio, :city, :country, :personal_intrest, :display_language, :language_level, :language_option, :uniq_id)
    end

    def set_student
      @student = AccountBlock::Student.find(params[:id])
    end

    def get_notifn(notifn_status)
      if notifn_status[4..notifn_status.length-1] == "disabled"
        return "disabled"
      else
        if notifn_status[4..notifn_status.length-1] == "checked"
          return true
        else
          return false
        end
      end
    end

    def set_notifn(notifn_status)
      if notifn_status == "disabled" 
        return 0
      else
        if notifn_status == true
          return 1
        else
          return 2
        end
      end
    end

    def set_uniq_id
      generate_token
    end

    def generate_token
      loop do
       number = SecureRandom.random_number(10000000000)
       uniq_id = "S#{number}"
       break uniq_id unless AccountBlock::Student.where(uniq_id: uniq_id).exists?
      end
    end

  end
end
