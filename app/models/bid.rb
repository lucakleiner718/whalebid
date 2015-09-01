class Bid < ActiveRecord::Base

  has_many :offers
  has_and_belongs_to_many :casinos
  belongs_to :user

  # accepts_nested_attributes_for :casinos, :allow_destroy => true

  validates :bid_name, presence: true

  validate :market_validator
  validate :casinos_validator

  before_create :before_create_process

  private
  def before_create_process
  	self.reference_number = rand.to_s[2..7]
  	self.close_at = Date.today + 7
  end

  private

  def market_validator
    errors[:market] << "should be selected" unless market_valid?
  end

  def market_valid?
    if by_market && market == ''
      false
    else
      true
    end
  end

  def casinos_validator
    errors[:casinos] << "should be selected" unless casinos_valid?
  end

  def casinos_valid?

    if by_market
      true
    elsif casinos.any?
      true
    else
      false
    end
  end

end
