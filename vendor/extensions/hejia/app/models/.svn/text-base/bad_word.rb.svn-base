#敏感词过滤
class BadWord
  def self.all(key)
    $redis && $redis.smembers(key) || []
  end
   
  def self.find(key , member)
    member if $redis && $redis.sismember(key , member)
  end
   
  def self.like(member)
    self.all.select{|word| word =~ /#{member}/}
  end
   
end