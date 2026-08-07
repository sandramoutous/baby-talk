class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @children = @user.children.order(:name)
    @words_count = @user.words.count
    @audio_count = @user.words.joins(:audio_attachment).count
    @last_word = @user.words.where.not(said_on: nil).order(said_on: :desc).first
  end
end
