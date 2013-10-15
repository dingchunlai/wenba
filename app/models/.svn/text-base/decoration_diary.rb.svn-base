class DecorationDiary < Hejia::Db::Hejia

  def self.getNote(id)
    id.strip! if id.respond_to?(:strip!)
    CACHE.fetch("decoration_diary/#{id}", RAILS_ENV == 'production' ? 1.hour : 1) do
      find_by_id id
    end
  end

end
