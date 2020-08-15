
# frozen_string_literal: true
class Stackexg::QuestionsController < Spree::Api::BaseController
	DOMAIN="localhost"
	def index
		if params[:code].blank?
			if cookies[:stackexg_oauthtoken].blank?
				redirect_to "http://stackoverflow.com/oauth?client_id=18552&redirect_uri=http://#{DOMAIN}/get_questions&scope=no_expiry"
			else
				#Application is already register
			end
		else
			cookies[:stackexg_oauthtoken] = {
		       :value => params[:code],
		       :expires => 1.year.from_now,
		       :domain => DOMAIN #it should be automatically configured according to the environment
		    }
		end
		#debugger
		if !params[:code].blank?
        else
	    end

	end

	def redirects
		redirect_to "/get_questions"
	end
end
