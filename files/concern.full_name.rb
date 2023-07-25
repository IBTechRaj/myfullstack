require 'active_support/concern'

module FullName
    extend ActiveSupport::concern
included do
    def full_name
        "#{first_name} #{last_name}"
    end
end
end
