if Rails.env.development?
  require 'pronto'
  require 'dotenv/tasks'

  namespace :pronto do
    task comment: :dotenv do
      formatter = Pronto::Formatter::GithubPullRequestFormatter.new
      Pronto.run('origin/master', '.', formatter)
    end
  end
end
