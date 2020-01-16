# frozen_string_literal: true

Spree::Api::ApiHelpers.module_eval do
  mattr_reader :review_attributes, default: [
    :id, :product_id, :name, :location, :rating, :title, :review, :approved,
    :created_at, :updated_at, :user_id, :ip_address, :locale, :show_identifier,
    :verified_purchaser
  ]

  mattr_reader :feedback_review_attributes, default: [
    :id, :user_id, :review_id, :rating, :comment, :created_at, :updated_at, :locale
  ]
end
