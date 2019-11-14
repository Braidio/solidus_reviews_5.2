# frozen_string_literal: true

class Spree::ReviewsController < Spree::StoreController
  helper Spree::BaseHelper
  before_action :load_product, only: [:index, :new, :create]

  def index
    @approved_reviews = Spree::Review.approved.where(product: @product)
  end

  def new
    @review = Spree::Review.new(product: @product)
    authorize! :create, @review
  end

  # save if all ok
  def create
    params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') if params[:review][:rating].present?

    @review = Spree::Review.new(review_params)
    @review.product = @product
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]
    # Handle images
    params[:review][:images]&.each do |image|
      @review.images.new(attachment: image)
    end

    authorize! :create, @review
    if @review.save
      flash[:notice] = I18n.t('spree.review_successfully_submitted')
      redirect_to spree.product_path(@product)
    else
      render :new
    end
  end

  private

  def load_product
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def permitted_review_attributes
    [:rating, :title, :review, :name, :show_identifier, :images]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
end
