class Post < ApplicationRecord
  belongs_to :user
  belongs_to :city
  acts_as_votable
  acts_as_taggable_on :tags

  validates :name, :address,:description,:category, presence: true

end
