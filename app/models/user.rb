class User < ApplicationRecord
	validates_uniqueness_of :email
	validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	PAGE =1
	PER_PAGE=3


	def self.typehead(input)
		where("email like ? OR firstName like ? OR lastName like ?", "#{input}%","#{input}%","#{input}%")
	end


end
