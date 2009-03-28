namespace :db do
  task :recreate => [:environment, :drop_and_create, :migrate, "test:prepare"] 

  task :drop_and_create do
    conn = ActiveRecord::Base.connection
    conn.execute 'DROP DATABASE manitu;'
    conn.execute 'CREATE DATABASE manitu;'
    #ActiveRecord::Base.connection = nil
    ActiveRecord::Base.establish_connection "development"
  end
end