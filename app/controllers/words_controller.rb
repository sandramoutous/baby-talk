class WordsController < ApplicationController
  before_action :set_child, only: [ :new, :create ]
  before_action :set_word, only: [ :show, :edit, :update, :destroy ]

  def new
    @word = @child.words.new
  end

  def create
    @word = @child.words.new(word_params)
    if @word.save
      redirect_to @child, notice: "\"#{@word.baby_version}\" ajouté au carnet."
    else
      redirect_to @child, alert: "Impossible d'ajouter ce mot."
    end
  end

  def edit
  end

  def update
    if @word.update(word_params)
      redirect_to @child, notice: "Mot mis à jour.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word.destroy
    redirect_to @child, notice: "Mot supprimé.", status: :see_other
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def set_word
    @word  = current_user.words.find(params[:id])
    @child = @word.child
  end

  def word_params
    params.require(:word).permit(:baby_version, :real_meaning, :context, :said_on, :audio, :remove_audio)
  end
end
