require 'coveralls'
Coveralls.wear!

require 'active_record'
require 'fake_associations'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

class Post < ActiveRecord::Base; end

ActiveRecord::Migration.verbose = false
ActiveRecord::Migration.create_table :posts do |t|
  t.string :content
  t.integer :user_id
end

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
