# Store URLs in Redis.
# All URLs are keyed by APP_PREFIX:URL:id
# and are represented as a hash with a URL key and a "count" key 
# representing the number of times the URL was accessed.
#
# Usage: 
#   connection = Redis.new
#   store = UrlStore.new(connection, "USHORT")
#   store.get(1)
#   => {"url" => "http://twitter.com", "count" => 1"}
#   store.set("http://facebook.com")
#   => 2
class UrlStore

  # Accept the Redis store we're using for the app and
  # the prefix we'll use for the app so we can build
  # the key for each object.
  def initialize(redis, app_prefix)
    @redis = redis
    @prefix = "#{app_prefix}:URL"
  end

  # Retrieves the data hash for the ID.
  def get(id)
    @redis.hgetall "#{@prefix}:#{id}"
  end

  # Stores a new URL
  def set(url)
    id = next_id
    @redis.hmset "#{@prefix}:#{id}", "url", url, "count", 0
    id
  end

  # TODO (2014-11-10) bph => Add a way to increase the count for a url.


  # get new  url ID. It should either be the last stored
  # value or it should start at 0.
  private def next_id
    @redis.get("#{@prefix}:next_url_id") || REDIS.set("#{@prefix}:next_url_id", 0)
    @redis.incr("#{@prefix}:next_url_id")
  end
end
