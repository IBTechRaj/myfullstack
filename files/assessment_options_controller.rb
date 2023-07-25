module AccountBlock 
  class AssessmentOptionsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token 

    def create
      @assessment_options = AssessmentOption.new(assessment_options_params)
      if @assessment_options.save
        render json: AssessmentOptionsSerializer.new(@assessment_options).serializable_hash, status: :created
      else
        render json:{errors: @assessment_options.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private
    
    def assessment_options_params
      params.permit(:assessment_question_id,:answer, :assessment_question_no)
    end
  end
end