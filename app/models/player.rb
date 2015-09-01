class Player < ActiveRecord::Base
  belongs_to :user

  mount_uploader :avatar, AvatarUploader

  validates :phone, format: { with: /\A\(\d{3}\) \d{3}-\d{4}\Z/, message: "Phone number should be (###) ###-####" }

  validates :username, length: { minimum: 6 }

end
