# frozen_string_literal: true

FactoryBot.define do
  factory :state do
    transient do
      work { FactoryBot.create_for_repository(:project) }
    end

    creator_id    { Minerva::User.find_or_create_by(auid: '1').id }
    user_id       { Minerva::User.find_or_create_by(auid: '2').id }
    work_id       { Minerva::Work.find_or_create_by(auid: work.noid).id }
    # TODO: make multiple interface factories and get rid of this one off
    interface_id  { create(:interface, code_point: 'tasks#encode').id }
    status        { Status.available.name }
  end
end
