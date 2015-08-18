# FakeAssociation

To enable to use ActiveRecord association in the module is not ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fake_association'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_association

## Usage

It has been confirmed that the following code to work

```ruby
class User

  # Need
  attr_accessor :id
	
  has_many :tweets
	
  has_many :friendships, foreign_key: 'follower_id'
  has_many :followed_user, through: :friendships, source: :followed
	
  has_many :reverse_friendships, foreign_key: 'followed_id', class_name: 'Friendship'
  has_many :followers, through: :reverse_friendships, source: :follower
	
  has_many :favorite_tweets, through: :favorites, source: :tweet
end

class Friendship < ActiveRecord::Base
#  Table name: friendships
#
#  id          :integer  not null, primary key
#  follower_id :integer
#  followed_id :integer
end

class Tweet < ActiveRecord::Base
#  Table name: tweets
#
#  id          :integer  not null, primary key
#  user_id     :integer
end

class Favorite < ActiveRecord::Base
#  Table name: favorites
#
#  id          :integer  not null, primary key
#  user_id     :integer
#  tweet_id    :integer
end
```

## Limitation

Support associations is only `has_many` and limited options.

In the future, will support more association.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fake_association.

