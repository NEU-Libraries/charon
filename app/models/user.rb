# frozen_string_literal: true

class User < ApplicationRecord
  enumeration :capacity
  has_many :roles

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include Blacklight::AccessControls::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  after_initialize do |user|
    user.capacity = Capacity.user if user.capacity.nil?
  end

  def dev?
    capacity == :developer
  end

  def admin?
    dev? || capacity == :administrator
  end

  def projects; end

  def to_s
    # Blacklight presentation string
    "#{first_name} #{last_name}"
  end
end
