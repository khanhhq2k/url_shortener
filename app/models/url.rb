class Url < ApplicationRecord
  validates_presence_of :hash_value
  validates_presence_of :original_url

  validates :hash_value, uniqueness: true
end
