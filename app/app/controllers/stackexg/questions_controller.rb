
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
		search_keyword  = "android" 
		@results = {}
		@results["Latest #{search_keyword} Questions"]     = get_questions_details search_keyword, "creation"
		@results["Most Voted #{search_keyword} Questions"] = get_questions_details search_keyword, "votes"
		debugger
	end

	def redirects
		redirect_to "/get_questions"
	end

	private 
	def get_questions_details search_keyword, sort
		search_keyword = search_keyword.capitalize
		require 'open-uri'
		questions_query = "https://api.stackexchange.com/2.2/questions?page=1&pagesize=10&fromdate=1597449600&todate=1598054400&order=desc&sort=#{sort}&tagged=#{search_keyword}&site=stackoverflow&auth_token=#{cookies[:stackexg_oauthtoken]}"
		debugger
		response    = open(questions_query).read
		json_result = JSON.parse(response)
		questions   = []
		json_result["items"].each_with_index do |item,i|
			next if item["answers_count"] == 0
			temp_item = []
			temp_item << item["title"].capitalize
			answers_query 	 = "https://api.stackexchange.com/2.2/questions/#{item["question_id"]}?order=desc&sort=activity&site=stackoverflow&filter=!E-PH4Kvk4lz6dx697PeHVXbH8._5NUJXUwyenL&auth_token=#{cookies[:stackexg_oauthtoken]}"
			answers    		 = open(answers_query).read
			answers_response = JSON.parse(answers)
			answers = []
			answers_response["items"].each_with_index do |item,i|
				answers << item["body"]
			end
			temp_item << answers
			questions << temp_item
		end
		return questions
	end
end
