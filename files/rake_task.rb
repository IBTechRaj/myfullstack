rake task:
lib/tasks/language_classes.rake

namespace :language_classes do
	task cancel_minimum: :environment do
		current_time = Time.now
		language_classes = BxBlockClassses::LanguageClass.where('date < ?', current_time + 24.hours)
language_classes.each do | language_class |
puts 'canceled' if language_classes.fully_booked?
end
end
end