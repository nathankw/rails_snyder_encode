class SequencingResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :sequencing_request
	belongs_to :report, class_name: "Document"
	has_many    :library_sequencing_results, dependent: :destroy

	validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
	validates :run_name, presence: true

	def self.policy_class
		ApplicationPolicy
	end
end