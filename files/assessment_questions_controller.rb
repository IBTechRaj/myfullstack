module AccountBlock 
  class AssessmentQuestionsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token 

    def create
      @assessment_questions = AssessmentQuestion.new(assessment_questions_params)
      if @assessment_questions.save
        render json: AssessmentQuestionsSerializer.new(@assessment_questions).serializable_hash, status: :created
      else
        render json:{errors: @assessment_questions.errors.full_messages}, status: :unprocessable_entity
      end

    end

    private
    
    def assessment_questions_params
      params.permit(:level,:question,:question_no,:answer,:language)
    end
  end

end