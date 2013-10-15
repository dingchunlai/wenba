module Hejia
 
  Cache = if defined?(PUBLISH_CACHE)
    PUBLISH_CACHE
  elsif defined?(CACHEAPI)
    CACHEAPI
  else
    Hejia[:cache]
  end

end