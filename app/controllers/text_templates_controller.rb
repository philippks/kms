class TextTemplatesController < ApplicationController
  load_and_authorize_resource :activity_category
  load_and_authorize_resource through: :activity_category

  responders :flash

  def index
    @text_templates = @text_templates.order(:text)
  end

  def create
    @text_template.save
    respond_with @text_template, location: activity_category_text_templates_path
  end

  def update
    @text_template.update text_template_params
    respond_with @text_template, location: activity_category_text_templates_path
  end

  def destroy
    @text_template.destroy
    respond_with @text_template, location: activity_category_text_templates_path
  end

  private

  def text_template_params
    params.require(:text_template).permit :text, :activity_category_id
  end
end
