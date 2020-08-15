
# frozen_string_literal: true
include MenuHelper
class Odrnow::Api::MenuController < Spree::Api::BaseController
	def load_menu_for_resturant
		if !params[:code].blank?
	    	resturant  = Resturant.find_by_code(params[:code].upcase)
	      	products   = resturant.products.eager_load(:taxons).eager_load(:prices)
	      	@result    = {}
	      	products.each do |product|
	      		variant_hash = {}
	      		all_variants = product.variants.eager_load(:prices)
	      		all_variants.each do |variant|
	      			price = variant.prices.first
	      			variant_hash[variant.option_values.first.presentation] = [price.amount.to_i,currency_symbol(price.currency)]
	      		end
	        	product.taxons.each do |taxon|

	          		prod_array = [product.name, product.prices.first.amount.to_i, variant_hash]
	          		if !@result[taxon.taxonomy.name].blank?
	          			add_taxon_to_result taxon,prod_array
	          		else
	          			@result[taxon.taxonomy.name] = {}
	          			add_taxon_to_result taxon,prod_array	
	          		end
	          	end
	        end
	        render json: @result 
	    end	  
	end

	private 
	def add_taxon_to_result taxon, prod_array
		if !@result[taxon.taxonomy.name][taxon.name].blank?
			@result[taxon.taxonomy.name][taxon.name] << prod_array
		else
			@result[taxon.taxonomy.name][taxon.name] = prod_array
		end
	end
end
