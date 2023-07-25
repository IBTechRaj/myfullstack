module AccountBlock
  class StudentSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :email,
      :city,
      :country,
      :bio,
      :personal_intrest,
      :language_level,
      :language_option,
      :uniq_id,
      :display_language,
      :image_link
    ]
    attribute :image_link do |object|
      object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(
        object.image
      ) : nil
    end
  end
end
