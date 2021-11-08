# frozen_string_literal: true

module StateHelper
  def make_upload_state(upload, work)
    upload_state = Minerva::State.new(
      creator_id: minerva_user_id(upload.user.id),
      work_id: minerva_work_id(work.noid),
      interface_id: upload_interface.id,
      status: Status.complete.name,
      message: "#{upload.user.name} has uploaded #{work.title}" # Test Admin has uploaded test_pic.jpeg
    )
    raise StandardError, upload_state.errors.full_messages unless upload_state.save
  end

  def make_approval_state
    upload_approval_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(saved_work.noid),
      status: Status.available.name,
      message: 'available'
    )
    upload_approval_state.created_at = Time.zone.now + 1
    raise StandardError, upload_approval_state.errors.full_messages unless upload_approval_state.save
  end

  def make_edit_state
    edit_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(page.parent.parent.noid),
      status: Status.edited.name,
      message: 'Edited'
    )

    raise StandardError, edit_state.errors.full_messages unless edit_state.save
  end

  def make_claim_state
    claim_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(work.noid),
      status: Status.claimed.name,
      message: 'Claimed'
    )

    raise StandardError, claim_state.errors.full_messages unless claim_state.save
  end

  def make_catalog_state
    catalog_state = Minerva::State.new(
      creator_id: minerva_user_id(current_user.id),
      work_id: minerva_work_id(work.noid),
      interface_id: catalog_interface.id,
      status: Status.in_progress.name,
      message: 'In Progress'
    )

    raise StandardError, catalog_state.errors.full_messages unless catalog_state.save
  end

  def claim_path(state)
    return if state.interface_id.blank?

    path_array = Interface.find(state.interface_id).code_point.split('#')
    url_for(controller: path_array[0],
            action: path_array[1],
            id: Work.find(
              Minerva::Work.find(state.work_id).auid
            ).noid)
  end
end
