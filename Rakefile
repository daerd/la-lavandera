desc 'Server run to preview the website.'
task :server do
  system('bundle exec middleman --bind-address 0.0.0.0')
end

desc 'Website generation into the /build path.'
task :build do
  system('bundle exec middleman build --verbose')
end

desc 'Deploy with environment variables load.'
task :deploy do
  system("export $(grep -v '^#' .env) && bundle exec middleman deploy")
end
