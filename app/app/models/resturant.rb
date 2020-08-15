class Resturant < ActiveRecord::Base
	has_many :product_resturants
	has_many :products, :through => :product_resturants, class_name: 'Spree::Product'
	validates :code, presence: true
end

