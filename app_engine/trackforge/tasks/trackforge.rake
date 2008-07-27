#override community_engine's own 
require 'rake/clean'

namespace :db do
  namespace :tables do
    desc 'Blow away all your database tables.' 
    task :drop => :environment do 
      ActiveRecord::Base.establish_connection 
      ActiveRecord::Base.connection.tables.each do |table_name| 
        # truncate resets the auto_increment counters
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name}") 
        ActiveRecord::Base.connection.execute("DROP TABLE #{table_name}") 
      end 
    end
  end
end

namespace :trackforge do   
  
  desc 'Move the community engine assets to application public directory'
  task :mirror_public_assets => :environment do
    # actually, no need to do anything here, the mere act of running rake mirrors the plugin assets for everything
    # Engines::Assets.mirror_files_for(Rails.plugins[:community_engine])
  end

  desc 'load a bunch of test users RAILS_ENV= NUM_USERS='
  task :load_test_users => [:environment]  do
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    num = ENV['NUM_USERS'] || 1000
    puts "-- LOADING NUM_USERS: #{num}"
    (0..num.to_i).each do |n|
       login_name = "#{Faker::Internet.user_name}"
       printf "#{login_name}," if (n.remainder(100) == 0)
       u= User.new(
         :login=> login_name,
         :email => Faker::Internet.email,
         :password=>"standard",
         :password_confirmation=>"standard",
         :activated_at => Time.now.to_s(:db),
         :description => Random.paragraphs(3),
         :birthday => Random.date_between(Date.parse('1966-11-15')..Date.parse('1990-01-01')),
         :featured_writer => Random.boolean,
         :profile_public => Random.boolean,
         :role_id => Random.number(3)
       )
       u.save!
    end
    puts "" 
  end

  desc 'load a bunch of test posts RAILS_ENV= NUM_USERS='
  task :load_test_posts=>[:environment]  do
    require 'faker'
    require 'random_data'

    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    users = User.find(:all, :limit => 10)
    categories = Category.find(:all)

    num = ENV['NUM_POSTS'] || 20000
    puts "-- LOADING NUM_POSTS: #{num}"

    (0..num.to_i).each do |n|
       printf "#{n}." if (n.remainder(1000) == 0)

       p = Post.new(
       :title=>Random.paragraphs(1),
       :raw_post=> Random.paragraphs(5),
       :user => users[rand(users.size-1)],
       :published_as => 'live',
       :published_at => Time.now,
       :category => categories[rand(categories.size-1)]
          )
          p.save!
    end
    puts "" 
  end

  desc 'load a bunch of test posts RAILS_ENV= NUM_USERS='
  task :load_test_post_comments=>[:environment]  do
    require 'faker'
    require 'random_data'

    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    users = User.find(:all)
    posts = Post.find(:all)

    num = ENV['NUM_COMMENTS'] || 40000
    puts "-- LOADING NUM_COMMENTS: #{num}"

    (0..num.to_i).each do |n|
       printf "#{n}." if (n.remainder(1000) == 0)

       commentable = posts[rand(posts.size-1)]
       user = users[rand(users.size-1)]

       c = Comment.new(
       :comment=> "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor      incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation Duis aute irure dolor in reprehenderit cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat ",
       :commentable => commentable,
       :commentable_type => commentable.class.to_s,
       :recipient => commentable.owner,
       :user => user
          )
          c.save!
    end
    puts "" 
  end
  
  desc 'load genres'
  task :load_genres => :environment do 
    require 'csv'
    # truncate the current genres table
    ActiveRecord::Base.connection.execute('truncate genres')
    
    csv_path = "#{File.dirname(__FILE__)}/genres.csv"
    puts "Loading #{csv_path}"
    CSV.open(csv_path,'r') do |row|
      puts row[1].to_s + "\n"
      
      main = 0
      main = 1 if row[2].to_i == 0
      
      Genre.create({:code => row[0].to_i, :name => row[1].to_s, :main => main})
      Tag.create(:name => row[1])
    end

  end


  desc 'load licenses'
  task :load_licenses => :environment do
    require 'active_record/fixtures'
    
    `rake db:migrate:redo VERSION=20080721151031`
    
    f = Fixtures.create_fixtures("#{RAILS_ROOT}/app_engine/trackforge/tasks/fixtures", File.basename('licenses', '.yml') )
    puts f
  end

end