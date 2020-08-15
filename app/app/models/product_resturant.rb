class ProductResturant < ActiveRecord::Base
	belongs_to :product, class_name: 'Spree::Product'
	belongs_to :resturant
end
