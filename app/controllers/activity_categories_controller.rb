class ActivityCategoriesController < ApplicationController
  load_and_authorize_resource
  responders :flash

  def index
    @activity_categories = @activity_categories.includes(:text_templates).order(:name)
  end

  def create
    @activity_category.save
    respond_with @activity_category, location: activity_categories_path
  end

  def update
    @activity_category.update activity_category_params
    respond_with @activity_category, location: activity_categories_path
  end

  def destroy
    @activity_category.destroy
    respond_with @activity_category
  end

  private

  def activity_category_params
    params.require(:activity_category).permit :name
  end
end
