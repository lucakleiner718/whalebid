class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :player
  accepts_nested_attributes_for :player, :allow_destroy => true
  has_one :casino
  accepts_nested_attributes_for :casino, :allow_destroy => true

  has_many :bids


  def close_account
  	update_attributes({:closed_at=>Time.current, :status=>"closed"})
  end

  def fullname
    if self.player.present?
      "#{self.player.username}"
    elsif self.casino.present?
      "#{self.casino.contact_first_name} #{self.casino.contact_last_name}"
    else

    end  
  end

end
