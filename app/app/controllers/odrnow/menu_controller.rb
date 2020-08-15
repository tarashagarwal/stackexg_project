
# frozen_string_literal: true
include MenuHelper
class Odrnow::MenuController < ApplicationController
  def index
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

          prod_array = [product.name, product.prices.first.amount.to_i, variant_hash,(product.class_type.blank? ? "nonveg" : product.class_type)]
          if !@result[taxon.taxonomy.name].blank?
            add_taxon_to_result taxon,prod_array
          else
            @result[taxon.taxonomy.name] = {}
            add_taxon_to_result taxon,prod_array  
          end
        end
      end
    end
    @title="OdrNow!-#{resturant.name.capitalize}"  
  end

  private 
  def add_taxon_to_result taxon, prod_array
    if !@result[taxon.taxonomy.name][taxon.name].blank?
      @result[taxon.taxonomy.name][taxon.name] << prod_array
      #@result[taxon.taxonomy.name][taxon.name] << prod_array
    else
      @result[taxon.taxonomy.name][taxon.name] = []
      @result[taxon.taxonomy.name][taxon.name] << prod_array
      #@result[taxon.taxonomy.name][taxon.name] << prod_array
    end
  end
end
