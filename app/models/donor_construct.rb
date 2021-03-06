require 'elasticsearch/model'
class DonorConstruct < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ModelConcerns
  ABBR = "DONC"
  DEFINITION = "A DNA construct (i.e. plasmid) that you or a third party created using a Cloning Vector for a CRISPR experiment, or some other type of genetic modification experiment, which contains the sequence to insert into the genome for editing.  Model abbreviation: #{ABBR}"
  default_scope {order("lower(name)")}
  attr_accessor :construct_tag_ids

  has_and_belongs_to_many :construct_tags
  has_many :crispr_modifications
  has_and_belongs_to_many :documents, dependent: :nullify
  belongs_to :sent_to, class_name: "Address"
  belongs_to :user
  belongs_to :cloning_vector
  belongs_to :vendor
  belongs_to :target

  validates :name, presence: true
  validates :cloning_vector, presence: true
  validates :primer_left_forward, format: { with: /\A[acgtnACGTN]+\z/, message: "can only contain characters in the set ACTGN" }, allow_blank: true
  validates :primer_left_reverse, format: { with: /\A[acgtnACGTN]+\z/, message: "can only contain characters in the set ACTGN" }, allow_blank: true
  validates :primer_right_forward, format: { with: /\A[acgtnACGTN]+\z/, message: "can only contain characters in the set ACTGN" }, allow_blank: true
  validates :primer_right_reverse, format: { with: /\A[acgtnACGTN]+\z/, message: "can only contain characters in the set ACTGN" }, allow_blank: true
  validates :insert_sequence, format: { with: /\A[acgtnACGTN]+\z/, message: "can only contain characters in the set ACTGN" }, allow_blank: true
  validates :vendor_id, presence: true
  validates :target_id, presence: true
  validates :construct_tags, presence: true

  accepts_nested_attributes_for :construct_tags, allow_destroy: true
  accepts_nested_attributes_for :documents, allow_destroy: true

  scope :persisted, lambda { where.not(id: nil) }

  # Overwrite Elasticsearch method
  def as_indexed_json(options={})
    as_json(except: [:insert_sequence])
  end

  def self.policy_class
    ApplicationPolicy
  end

  def document_ids=(ids)
    """
    Function : Adds associations to Documents that are stored in self.documents.
    Args     : ids - array of Document IDs.
    """
    ids.each do |i|
      if i.blank?
        next
      end
      doc = Document.find(i)
      if not self.documents.include? doc
        self.documents << doc
      end
    end
  end

  def construct_tag_ids=(ids)
    ids.each do |i|
      if i.present?
        construct = ConstructTag.find(i)
        if self.construct_tags.include?(construct)
          next
        end
        self.construct_tags << construct
      end
    end
  end

end
