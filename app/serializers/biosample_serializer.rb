class BiosampleSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :date_biosample_taken, :description, :lot_identifier, :name, :nih_institutional_certification, :part_of_biosample_id, :passage_number, :starting_amount, :starting_amount_units, :submitter_comments, :tissue_preservation_method, :tube_label, :vendor_product_identifier, :upstream_identifier, :created_at, :updated_at

  has_one :biosample_term_name
  has_one :biosample_type
  has_one :crispr_modification
  has_one :donor
  has_one :vendor

  has_many :documents
  has_many :pooled_from_biosamples
  has_many :treatments

end
