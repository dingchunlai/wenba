# encoding: utf-8
ActionController::Base.helpers_dir = [ActionController::Base.helpers_dir, File.expand_path('../../../app/helpers', __FILE__)]

class << ActionController::Base
  private

  # Extract helper names from files in app/helpers/**/*.rb
  def all_application_helpers
    helpers_dir.inject([]) do |files, dir|
      extract = /^#{Regexp.quote(dir)}\/?(.*)_helper.rb$/
      Dir["#{dir}/**/*_helper.rb"].map { |file| files << file.sub(extract, '\1') }
      files.uniq!
      files
    end
  end
end
