class Offer < ActiveRecord::Base
  
  belongs_to :bid
  belongs_to :casino
  mount_uploader :attach_file_to_message, FileUploader
  mount_uploader :attach_file_to_offer, FileUploader

  before_create :before_create_process

  private
  def before_create_process
  	self.reference_number = rand.to_s[2..7]
  end
   
end
