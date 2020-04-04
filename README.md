# LetsShard

LetsShard is an easy way to shard and distribute load/use on any set of objects!
One of the best uses is to shard [Redis](https://redis.io/)

So simply run your instances and let **LetsShard** shard your usage on them!

**LetsShard** distributes and shards things in a way somehow similar to [Redis Cluster](https://redis.io/topics/cluster-tutorial)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lets_shard'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lets_shard

## Usage

```ruby
require 'lets_shard'

objects = (0..10).map { |_| AnyObject.new } # AnyObject is an arbitrary class and not included in the gem.

my_shards = LetsShard.new(objects)

# To see all objects including the intervals they cover
my_shards.shards

# To get the object that covers "blah"
my_object = my_shards.get_object("blah")
my_object.foo

# To get the shard (including the intervals and the object it self) that covers "blah"
my_shard = my_shards.get_shard("blah")

# To see slots/intervals that "my_shard" covers
my_shard.start_slot
my_shard.end_slot

# To use the object of this interval
my_shard.object.foo
```

### An example with redis

```ruby
require 'lets_shard'
require 'redis'

redis1 = Redis.new(host: "10.0.0.1", port: 6379)
redis2 = Redis.new(host: "10.0.0.2", port: 6379)

redis_shards = LetsShard.new([redis1, redis2])

redis_shards.get_object('key').set('key', 'value')
redis_shards.get_object('key').get('key')

# redis_shards.get_object('key').any_redis_command
```

### LetsShard let you distribute objects usage better!

If you are using 3 redis instances in 3 servers, but one of these servers has more
powerful specifications than the others and you want to utilize its power.

**LetsShard** can solve it for you, easily!

```ruby
require 'lets_shard'
require 'redis'

redis1 = Redis.new(host: "10.0.0.1", port: 6379) # The most powerful server
redis2 = Redis.new(host: "10.0.0.2", port: 6379)
redis3 = Redis.new(host: "10.0.0.3", port: 6379)

redises = [redis1, redis2, redis3]
weights = [2, 1, 1] # By default, the weight of each object is 1

redis_shards = LetsShard.new(redises, weights: weights)

# So now LetsShard will give redis1 more slots to utilize it more!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/oshboul/lets_shard. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/lets_shard/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the LetsShard project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lets_shard/blob/master/CODE_OF_CONDUCT.md).


## License

LetsShard is released under the [MIT License](https://opensource.org/licenses/MIT).
