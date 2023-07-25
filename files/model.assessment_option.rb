module AccountBlock  
	class AssessmentOption < ApplicationRecord
		self.table_name = :assessment_options

		validates :answer, presence: true		

	  belongs_to :assessment_question, class_name: 'AccountBlock::AssessmentQuestion'
	end
end
