module AccountBlock  
	class Assessment < ApplicationRecord
		self.table_name = :assessments

		validates :assessment_level, presence: true
		validates :assessment_score, presence: true
		validates :assessment_grade, presence: true
		validates :language, presence: true
		validates :assessment_date, presence: true

    
		# has_many :assessment_answers, dependent: :destroy, :inverse_of => :assessment
	end
end
