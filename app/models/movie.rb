class Movie < ActiveRecord::Base
    def self.all_ratings
        records = self.all
        ratings = records.group(:rating).pluck(:rating)
        return ratings
    end
end
