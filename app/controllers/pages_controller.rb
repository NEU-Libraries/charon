class PagesController < ApplicationController
  include Searchable

  before_action :searchable, only: [:home]

  def home
    raw = `cd #{Rails.root} && git log -n 20 --pretty="format:%h|%s"`
    @git_log = Hash.new
    raw.split("\n").each do |line|
      hsh_and_val = line.split('|', 2)
      @git_log[hsh_and_val[0]] = hsh_and_val[1]
    end
  end

end
