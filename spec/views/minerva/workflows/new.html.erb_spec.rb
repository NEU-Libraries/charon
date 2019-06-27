# frozen_string_literal: true

require 'spec_helper'

describe 'minerva/workflows/new.html.erb' do
  it 'appropiately raises a no method error with bad pathing' do
    stub_template 'minerva/workflows/new.html.erb' => '<%= bad_url_path %><br/>'
    expect { render }.to raise_error(ActionView::Template::Error)
  end
end
