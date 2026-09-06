class HomeController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]
  layout "landing", only: :index

  def index
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @children = current_user.children.order(:name)
    @last_word = Word.where(child_id: @children.pluck(:id))&.last
  end
end
