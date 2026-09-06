# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
