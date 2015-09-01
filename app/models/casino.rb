class Casino < ActiveRecord::Base
  
  belongs_to :user
  has_and_belongs_to_many :bids
  has_many :offers

  mount_uploader :avatar, AvatarUploader

  mount_uploader :casino_image_1, ImageUploader
  mount_uploader :casino_image_2, ImageUploader
  mount_uploader :casino_image_3, ImageUploader

  mount_uploader :feature_image_1, ImageUploader
  mount_uploader :feature_image_2, ImageUploader
  mount_uploader :feature_image_3, ImageUploader

  validates :casino_name, :casino_market, presence: true
  validates :address, :city, :state, :postal_code, :country, presence: true
  validates :phone, format: { with: /\A\(\d{3}\) \d{3}-\d{4}\Z/, message: "Phone number should be (###) ###-####" }

  before_validation :format_website
  validate :website_validator

  validates :contact_first_name, :contact_last_name, presence: true
  validates :office_phone, format: { with: /\A\(\d{3}\) \d{3}-\d{4}\Z/, message: "Phone number should be (###) ###-####" }
  validates :mobile_phone, format: { with: /\A\(\d{3}\) \d{3}-\d{4}\Z/, message: "Phone number should be (###) ###-####" }
  
  

  private

  def format_website
    if self.website != ''
      self.website = "http://#{self.website}" unless self.website[/^https?/]
    end
  end

  def website_validator
    errors[:website] << "is not valid" unless website_valid?
  end

  def website_valid?
    if website != ''
      !!website.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/)
    else
      true
    end
  end
  
end
