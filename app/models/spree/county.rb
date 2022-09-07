class Spree::County < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :state
  has_many :addresses
  has_many :stock_locations
  has_and_belongs_to_many :users

  validates :name, presence: true

  delegate :country, to: :state

  Spree::Ability.register_ability(CountyAbility)

  scope :by_name, -> (county_name) { where( 'lower(name) = ?',  county_name.downcase) }

  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end

  def country
    state.country
  end
end
