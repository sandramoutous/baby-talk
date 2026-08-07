class Word < ApplicationRecord
  belongs_to :child
  has_one_attached :audio

  validates :baby_version, presence: true

  attr_accessor :remove_audio

  before_save :purge_audio, if: -> { remove_audio == "1" }

  private

  def purge_audio
    audio.purge
  end
end
