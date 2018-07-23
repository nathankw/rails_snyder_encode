class CrisprModificationSerializer < ActiveModel::Serializer
  self.root = false
  embed :ids

  attributes :id, :biosample_id, :category, :donor_construct_id, :name, :notes, :purpose, :times_cloned, :upstream_identifier, :created_at, :updated_at, :upstream_identifier

  has_many :crispr_constructs
  has_many :documents
  has_many :pcr_validations
  has_many :crispr_constructs
end
