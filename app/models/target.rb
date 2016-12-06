class Target < ActiveRecord::Base
	self.primary_key = :encode_identifier
	has_many :antibodies
	belongs_to :user
	validates :encode_identifier, uniqueness: true, presence: true
	validates :name, presence: true

	def self.policy_class
		ApplicationPolicy
	end 
end