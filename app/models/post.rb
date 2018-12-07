class Post < ApplicationRecord
  belongs_to :user
  belongs_to :city
  acts_as_votable
end
