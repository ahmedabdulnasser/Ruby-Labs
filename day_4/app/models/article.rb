class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :content, presence: true
  before_update :archive_if_reported


  private
  def archive_if_reported
    self.status = 'archived' if reports_count >= 3
  end



end
