namespace :manitu do
  task :daemon => :environment do
    Manitu.daemon
  end
end