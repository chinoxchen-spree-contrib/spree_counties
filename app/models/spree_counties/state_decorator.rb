module SpreeCounties
  module StateDecorator
    def self.prepended(base)
      base.has_many :counties, -> { order('name ASC') }, dependent: :destroy
    end

    Spree::State.prepend(self)
  end
end
