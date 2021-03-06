require 'elasticsearch/model'

class SequencingLibraryPrepKit < ActiveRecord::Base
  include Elasticsearch::Model                                                                         
  include Elasticsearch::Model::Callbacks
  include ModelConcerns
  ABBR = "SLPK"
  DEFINITION = "A sequencing kit used to prepare your libraries, which can have multiple Barcode and Paired Barcode objects.  Model abbreviation: #{ABBR}"
  default_scope {order("lower(name)")}
  has_and_belongs_to_many :documents
  has_many :barcodes
  has_many :libraries
  has_many :paired_barcodes
  has_many :pooled_libraries
  has_many :sequencing_library_prep_kits
  belongs_to :user
  belongs_to :vendor
  #has a unique constraint on the combined columns :vendor_id and :name.

  validates :name, presence: true
  validates :vendor_id, presence: true
  validates_uniqueness_of :vendor_product_identifier, scope: :vendor_id, allow_blank: true
  validates_uniqueness_of :name, scope: :vendor_id
  accepts_nested_attributes_for :documents, allow_destroy: true

  scope :persisted, lambda { where.not(id: nil) }

  def self.policy_class
    ApplicationPolicy
  end

  def self.dual_indexing_kits
    return SequencingLibraryPrepKit.where({:supports_dual_indexing => true})
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
    
end
