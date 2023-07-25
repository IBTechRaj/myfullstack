migration : createLanguageClassesStudentsJoinTable

def change
	create_join_table :language_classes, :students
end
