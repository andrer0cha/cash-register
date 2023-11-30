# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :email, uniqueness: true, presence: true
  validates_presence_of(:first_name, :last_name)
end
