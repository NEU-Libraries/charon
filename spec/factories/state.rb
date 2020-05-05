# frozen_string_literal: true

include MinervaHelper

FactoryBot.define do
  factory :state do
    transient do
      work { FactoryBot.create_for_repository(:project) }
    end

    creator_id    { minerva_user_id(create(:admin).id) }
    user_id       { minerva_user_id(create(:user).id) }
    work_id       { minerva_work_id(work.noid) }
    # TODO: make multiple interface factories and get rid of this one off
    interface_id  { create(:interface, code_point: "tasks#encode").id }
    status        { Status.available.name }
  end
end
