module AccountBlock  
	class AssessmentQuestion < ApplicationRecord
		self.table_name = :assessment_questions

		has_many :assessment_options, dependent: :destroy, class_name:'AccountBlock::AssessmentOption'
		accepts_nested_attributes_for :assessment_options, allow_destroy: true

		validates :question, presence: true
		validates :question_no, presence: true, inclusion:{in: 1..80}
		validates :answer, presence: true
		validates :language, presence: true
		validates :question_no, uniqueness: {scope: :language}
		enum language: %i[English German Spanish French Portuguese BrazilianPortuguese]

	    validates :assessment_options, presence: {message:"Please provide options"}
	    validates :assessment_options, length: {is: 4, message:'should be exactly 4'}

 	end
end
