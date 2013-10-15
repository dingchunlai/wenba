# encoding: utf-8
# Load  initializers.
# Caution: use Kernel.load instead of load, since this file is evaluate in the context of an Plugin instance.
Dir[File.expand_path('../config/initializers/*.rb', __FILE__)].sort.each { |file| Kernel.load file } unless defined?(Hejia::HejiaEngine)

# 因为和hejia_ext_link这个gem矛盾，未免读到gem里面的文件，这里先预读出来。
require File.expand_path('../lib/chinese_dictionary', __FILE__)
