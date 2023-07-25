class TeacherSerializer
include FastJsonapi::ObjectSerializer

    attributes *[
        :first_name,
        :last_name,
        :email
]
    #     :city,
    #     :country,
    #     image_link
    # ]
    # attribute :image_link do |object|
    #     object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(
    #         object.image, only_path: true
    #     ) : nil
    # end
end

