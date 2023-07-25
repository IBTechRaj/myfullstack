# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_21_112616) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_categories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false, null: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "platform"
    t.string "user_type"
    t.integer "app_language_id"
    t.datetime "last_visit_at"
    t.boolean "is_blacklisted", default: false
    t.date "suspend_until"
    t.integer "status", default: 0, null: false
    t.string "stripe_id"
    t.string "stripe_subscription_id"
    t.datetime "stripe_subscription_date"
    t.integer "role_id"
    t.datetime "date_of_birth"
    t.string "city"
    t.string "country"
    t.string "language_taught"
    t.string "teaching_style"
    t.string "personal_intrest"
    t.string "background_of_industries"
    t.string "time_zone"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "assessment_answers", force: :cascade do |t|
    t.string "letter"
    t.string "answer"
    t.boolean "correct"
    t.bigint "assessment_question_id", null: false
    t.bigint "assessment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessment_id"], name: "index_assessment_answers_on_assessment_id"
    t.index ["assessment_question_id"], name: "index_assessment_answers_on_assessment_question_id"
  end

  create_table "assessment_options", force: :cascade do |t|
    t.string "answer"
    t.bigint "assessment_question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "assessment_question_no"
    t.index ["assessment_question_id"], name: "index_assessment_options_on_assessment_question_id"
  end

  create_table "assessment_questions", force: :cascade do |t|
    t.string "level"
    t.string "question"
    t.integer "question_no"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "language"
  end

  create_table "assessments", force: :cascade do |t|
    t.integer "student_id"
    t.string "assessment_level"
    t.integer "assessment_score"
    t.string "assessment_grade"
    t.date "assessment_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "language"
  end

  create_table "automatic_renewals", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "subscription_type"
    t.boolean "is_auto_renewal", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_automatic_renewals_on_account_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "service_provider_id"
    t.string "start_time"
    t.string "end_time"
    t.string "unavailable_start_time"
    t.string "unavailable_end_time"
    t.string "availability_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "timeslots"
    t.integer "available_slots_count"
    t.index ["service_provider_id"], name: "index_availabilities_on_service_provider_id"
  end

  create_table "black_list_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_black_list_users_on_account_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_appointment_management_booked_slots", force: :cascade do |t|
    t.bigint "order_id"
    t.string "start_time"
    t.string "end_time"
    t.bigint "service_provider_id"
    t.date "booking_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_custom_user_subs_subscriptions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.date "valid_up_to"
  end

  create_table "bx_block_landingpage3_frequently_asked_questions", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_paypal_order_transactions", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "payment_method_id", null: false
    t.string "state", default: "pending"
    t.string "payment_reference_id"
    t.string "payment_capture_id"
    t.string "payment_refund_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_bx_block_paypal_order_transactions_on_order_id"
    t.index ["payment_method_id"], name: "index_bx_block_paypal_order_transactions_on_payment_method_id"
  end

  create_table "bx_block_paypal_orders", force: :cascade do |t|
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bx_block_paypal_payment_methods", force: :cascade do |t|
    t.string "slug"
    t.string "client_id"
    t.string "client_secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_reviews", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.string "comment"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["catalogue_id"], name: "index_catalogue_reviews_on_catalogue_id"
  end

  create_table "catalogue_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variant_sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogue_variants", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_variant_color_id"
    t.bigint "catalogue_variant_size_id"
    t.decimal "price"
    t.integer "stock_qty"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount_price"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["catalogue_id"], name: "index_catalogue_variants_on_catalogue_id"
    t.index ["catalogue_variant_color_id"], name: "index_catalogue_variants_on_catalogue_variant_color_id"
    t.index ["catalogue_variant_size_id"], name: "index_catalogue_variants_on_catalogue_variant_size_id"
  end

  create_table "catalogues", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.bigint "brand_id"
    t.string "name"
    t.string "sku"
    t.string "description"
    t.datetime "manufacture_date"
    t.float "length"
    t.float "breadth"
    t.float "height"
    t.integer "availability"
    t.integer "stock_qty"
    t.decimal "weight"
    t.float "price"
    t.boolean "recommended"
    t.boolean "on_sale"
    t.decimal "sale_price"
    t.decimal "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "block_qty"
    t.index ["brand_id"], name: "index_catalogues_on_brand_id"
    t.index ["category_id"], name: "index_catalogues_on_category_id"
    t.index ["sub_category_id"], name: "index_catalogues_on_sub_category_id"
  end

  create_table "catalogues_tags", force: :cascade do |t|
    t.bigint "catalogue_id", null: false
    t.bigint "catalogue_tag_id", null: false
    t.index ["catalogue_id"], name: "index_catalogues_tags_on_catalogue_id"
    t.index ["catalogue_tag_id"], name: "index_catalogues_tags_on_catalogue_tag_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_user_id"
    t.integer "rank"
    t.string "light_icon"
    t.string "light_icon_active"
    t.string "light_icon_inactive"
    t.string "dark_icon"
    t.string "dark_icon_active"
    t.string "dark_icon_inactive"
    t.integer "identifier"
  end

  create_table "categories_sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "sub_category_id", null: false
    t.index ["category_id"], name: "index_categories_sub_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_categories_sub_categories_on_sub_category_id"
  end

  create_table "cta", force: :cascade do |t|
    t.string "headline"
    t.text "description"
    t.bigint "category_id"
    t.string "long_background_image"
    t.string "square_background_image"
    t.string "button_text"
    t.string "redirect_url"
    t.integer "text_alignment"
    t.integer "button_alignment"
    t.boolean "is_square_cta"
    t.boolean "is_long_rectangle_cta"
    t.boolean "is_text_cta"
    t.boolean "is_image_cta"
    t.boolean "has_button"
    t.boolean "visible_on_home_page"
    t.boolean "visible_on_details_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_cta_on_category_id"
  end

  create_table "email_otps", force: :cascade do |t|
    t.string "email"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "features", force: :cascade do |t|
    t.integer "subscription_plan_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invitee_students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "activated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invitee_teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "activated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "language_classes", force: :cascade do |t|
    t.string "language"
    t.string "study_format"
    t.string "class_level"
    t.string "class_type"
    t.string "class_plan"
    t.date "class_date"
    t.time "class_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone"
  end

  create_table "language_courses", force: :cascade do |t|
    t.string "language_course_title"
    t.string "language_course_topic"
    t.string "language_course_class_frequency"
    t.string "language_course_study_format"
    t.string "language_course_medium"
    t.string "language_course_type"
    t.string "language_course_level"
    t.date "language_course_start_date"
    t.time "language_course_class_time"
    t.integer "language_course_slots"
    t.integer "language_course_total_classes"
    t.string "language_course_status"
    t.string "language_course_occurs_on"
    t.string "language_course_description"
    t.text "language_course_learning_results"
    t.bigint "teacher_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "language"
    t.string "category"
    t.integer "course_duration"
    t.integer "language_type"
    t.integer "language_level"
    t.index ["teacher_id"], name: "index_language_courses_on_teacher_id"
  end

  create_table "language_types", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "language_name"
  end

  create_table "payment_admins", force: :cascade do |t|
    t.string "transaction_id"
    t.bigint "account_id", null: false
    t.bigint "current_user_id"
    t.string "payment_status"
    t.integer "payment_method"
    t.decimal "user_amount", precision: 10, scale: 2
    t.decimal "post_creator_amount", precision: 10, scale: 2
    t.decimal "third_party_amount", precision: 10, scale: 2
    t.decimal "admin_amount", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_payment_admins_on_account_id"
    t.index ["current_user_id"], name: "index_payment_admins_on_current_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.float "price"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.string "name"
  end

  create_table "sms_otps", force: :cascade do |t|
    t.string "full_phone_number"
    t.integer "pin"
    t.boolean "activated", default: false, null: false
    t.datetime "valid_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone"
    t.string "date_format"
    t.string "time_format"
    t.integer "membership_notifn", default: 0
    t.integer "booked_cls_notfn", default: 0
    t.integer "canceled_cls_notifn", default: 0
    t.integer "cls_reminder_notifn", default: 0
    t.integer "cls_change_notifn", default: 0
    t.string "city"
    t.string "country"
    t.string "personal_intrest"
    t.string "language_level"
    t.string "language_option"
    t.text "bio"
    t.string "uniq_id"
    t.string "display_language"
  end

  create_table "study_formats", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.integer "rank"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "name"
    t.string "price_per_month"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo"
    t.boolean "isPopular", default: false
    t.boolean "isCurrent", default: false
    t.integer "study_format"
    t.integer "language_type"
    t.integer "language"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date_of_birth"
    t.string "city"
    t.string "country"
    t.string "language_taught"
    t.string "teaching_style"
    t.string "personal_intrest"
    t.string "background_of_industries"
    t.string "time_zone"
    t.text "bio"
    t.bigint "phone_number"
    t.integer "new_cls_request_notifn", default: 0
    t.integer "canceled_cls_notifn", default: 0
    t.integer "cls_reminder_notifn", default: 1
    t.integer "group_cls_notifn", default: 0
    t.integer "ending_group_course_notifn", default: 0
    t.integer "cls_availability_notifn", default: 1
    t.string "date_format"
    t.string "time_format"
    t.string "uniq_id"
    t.string "display_language"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "order_id"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "razorpay_signature"
    t.integer "account_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_categories_on_account_id"
    t.index ["category_id"], name: "index_user_categories_on_category_id"
  end

  create_table "user_sub_categories", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_user_sub_categories_on_account_id"
    t.index ["sub_category_id"], name: "index_user_sub_categories_on_sub_category_id"
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "subscription_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessment_answers", "assessment_questions"
  add_foreign_key "assessment_answers", "assessments"
  add_foreign_key "assessment_options", "assessment_questions"
  add_foreign_key "automatic_renewals", "accounts"
  add_foreign_key "black_list_users", "accounts"
  add_foreign_key "bx_block_paypal_order_transactions", "bx_block_paypal_orders", column: "order_id"
  add_foreign_key "bx_block_paypal_order_transactions", "bx_block_paypal_orders", column: "payment_method_id"
  add_foreign_key "catalogue_reviews", "catalogues"
  add_foreign_key "catalogue_variants", "catalogue_variant_colors"
  add_foreign_key "catalogue_variants", "catalogue_variant_sizes"
  add_foreign_key "catalogue_variants", "catalogues"
  add_foreign_key "catalogues", "brands"
  add_foreign_key "catalogues", "categories"
  add_foreign_key "catalogues", "sub_categories"
  add_foreign_key "catalogues_tags", "catalogue_tags"
  add_foreign_key "catalogues_tags", "catalogues"
  add_foreign_key "categories_sub_categories", "categories"
  add_foreign_key "categories_sub_categories", "sub_categories"
  add_foreign_key "payment_admins", "accounts"
  add_foreign_key "payment_admins", "accounts", column: "current_user_id"
  add_foreign_key "user_categories", "accounts"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_sub_categories", "accounts"
  add_foreign_key "user_sub_categories", "sub_categories"
end
