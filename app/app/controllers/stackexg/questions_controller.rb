
# frozen_string_literal: true
class Stackexg::QuestionsController < Spree::Api::BaseController
	DOMAIN="localhost" #it should be automatically configured according to the environment
	def index
		if params[:code].blank?
			if cookies[:stackexg_oauthtoken].blank?
				redirect_to "http://stackoverflow.com/oauth?client_id=18552&redirect_uri=http://#{DOMAIN}/get_questions&scope=no_expiry"
			else
				#Application is already registered
			end
		else
			cookies[:stackexg_oauthtoken] = {
		       :value => params[:code],
		       :expires => 1.hour.from_now,
		       :domain => DOMAIN
		    }
		end

		#calling qestions API
		search_keyword 		 = "android"
		require 'open-uri'

		get_latest_questions = "https://api.stackexchange.com/2.2/questions?page=1&pagesize=10&fromdate=1597449600&todate=1598054400&order=desc&sort=creation&tagged=#{search_keyword}&site=stackoverflow&auth_token=#{cookies[:stackexg_oauthtoken]}"
		response = open(get_latest_questions).read
		json_result = JSON.parse(response)
		questions = []
		json_result["items"].each_with_index do |item,i|
			questions << ([]<<item["title"])
		end
		@result = {}
		@result["latest"] = questions


		get_latest_questions = "https://api.stackexchange.com/2.2/questions?page=1&pagesize=10&fromdate=1597449600&todate=1598054400&order=desc&sort=votes&tagged=#{search_keyword}&site=stackoverflow&auth_token=#{cookies[:stackexg_oauthtoken]}"
		response = open(get_latest_questions).read
		json_result = JSON.parse(response)
		questions = []
		json_result["items"].each_with_index do |item,i|
			questions << ([]<<item["title"])
		end
		
		@result["voted"] = questions

		debugger

	end

	def redirects
		redirect_to "/get_questions"
	end
end
