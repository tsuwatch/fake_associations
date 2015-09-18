require 'coveralls'
Coveralls.wear!

require 'active_record'
require 'fake_associations'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

class Post < ActiveRecord::Base; end
class Favorite < ActiveRecord::Base
  belongs_to :post
end
class Friendship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate File.expand_path('../db/migrate', __FILE__), nil

require 'database_cleaner'

RSpec.configure do |config|
  config.order = :random

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
