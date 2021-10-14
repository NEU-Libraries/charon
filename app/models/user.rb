# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_messageable
  enumeration :capacity
  has_many :roles, dependent: :destroy
  has_one_attached :binary

  include RoleChecker
  include Blacklight::User
  include Blacklight::AccessControls::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  after_initialize do |user|
    user.capacity = Capacity.user if user.capacity.nil?
  end

  def projects; end

  def claims; end

  def last_action(project)
    minerva_work_ids = Minerva::Work.where(auid: project.works.map(&:noid).to_a).ids
    user_id = Minerva::User.find_by(auid: id)&.id
    return if user_id.blank?

    last_action = State.where(creator_id: user_id, work_id: minerva_work_ids).last
    if last_action.blank?
      # Look for their last assignment
      last_action = State.where(user_id: user_id, work_id: minerva_work_ids).last
    end
    last_action
  end

  def role(project)
    roles.find_by(user_registry_id: project&.user_registry&.id)
  end

  def designation(project)
    role(project)&.designation
  end

  def to_s
    # Blacklight presentation string
    "#{first_name} #{last_name}"
  end

  # using alias for Mailboxer
  alias name to_s

  def unread_notification_count
    mailbox.notifications(unread: true).count
  end
end
