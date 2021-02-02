class Spree::County < ActiveRecord::Base
  belongs_to :state
  has_many :addresses, dependent: :nullify
  has_many :stock_locations, dependent: :nullify
  validates :name, presence: true

  delegate :country, to: :state

  Spree::Ability.register_ability(CountyAbility)

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
