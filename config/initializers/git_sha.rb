mina_git = "/opt/#{ENV['PROJECT_NAME']}/current/.mina_git_revision"

GIT_SHA =
  if Rails.env.production? && File.exist?(mina_git)
    File.read(mina_git)
  elsif Rails.env.development? || Rails.env.test?
    `git rev-parse HEAD`.chomp
  else
    "Unknown SHA"
  end

HYRAX_VERSION =
    if File.exist?('Gemfile.lock')
      version_match = `grep 'hyrax (' Gemfile.lock`
      version_match.present? ? version_match.lines.first.chomp.lstrip.split(/ /)[1].gsub('(','').gsub(')','') : "Unknown"
    else
      "Unknown"
    end
