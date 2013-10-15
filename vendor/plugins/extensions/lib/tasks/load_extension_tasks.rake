Dir["#{RAILS_ROOT}/vendor/extensions/*/lib/tasks/**/*.rake"].sort.each { |ext| load ext }
