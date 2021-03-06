require 'elasticsearch/model'
class DataStorageProvider < ActiveRecord::Base
  include Elasticsearch::Model                                                                         
  include Elasticsearch::Model::Callbacks
  include ModelConcerns
  ABBR = "DSP"
  DEFINITION = "A cloud vendor that provides data storage services, i.e. AWS, Google, Azure, DNAnexus.  Model abbreviation: #{ABBR}"
  default_scope {order("lower(name)")}
  has_many :data_storages, dependent: :nullify
  belongs_to :user

  validates :name, presence: true, uniqueness: true

  AWS_S3_BUCKET = "AWS S3 Bucket"
  AZURE_STORAGE_ACCOUNT = "Azure Storage Account" #Equivalent to what AWS and Azure call bucket. 
  DNANEXUS = "DNAnexus"
  GOOGLE_STORAGE_BUCKET = "Google Storage Bucket"
  SCG = "Stanford Center for Genomics"
  
  PROVIDERS = [AWS_S3_BUCKET,AZURE_STORAGE_ACCOUNT,DNANEXUS,GOOGLE_STORAGE_BUCKET, SCG]

  validate :check_name_in_providers

  def self.policy_class
    ApplicationPolicy
  end

  private

  def check_name_in_providers
    if ! PROVIDERS.include?(self.name)
      self.errors[:name] << "not present in PROVIDERS list in model source code. When adding a new provider, the administrator will need to first update this list."
    end
  end

end
