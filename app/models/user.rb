class User < ApplicationRecord
	validates_uniqueness_of :email

	PAGE =1
	PER_PAGE=3

	def self.typehead(input)
		where("email like ? OR firstName like ? OR lastName like ?", "#{input}%","#{input}%","#{input}%")
	end


end
