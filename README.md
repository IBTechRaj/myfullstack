# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# rails new projectName --api -T --database="postgresql"
# Gemfile
gem "puma", "~> 5.0"
gem "bcrypt", "~> 3.1.7"
gem 'jwt'
gem 'fast_jsonapi'
gem 'pry-rails', "~> 0.3.9"
gem 'database_cleaner-active_record', '1.8.0.beta'

gem "rack-cors"

group :test do
    gem 'factory_bot_rails'
    gem 'faker'
end

cp  concern/json_web_token_validation.rb
cp controllers/student_controller.rb
cp mailers/student_email_verification.rb
cp models/student.rb
cp serializers/student_serializer.rb
cp services/email_validation.rb
cp services/json_web_token.rb
cp views/student_email_verification_mailer/....html.erb
cp ......text.erb
cp PasswordValidation
config/environment/development.rb .. SMTP creds
# myfullstack
