
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
		response        = open(questions_query).read
		json_result     = JSON.parse(response)
		questions       = []
		question_ids    = []
		question_titles = []
		json_result["items"].each_with_index do |item,i|
			question_titles << item["title"].capitalize
			question_ids    << item["question_id"]
		end


		answers_query 	 = "https://api.stackexchange.com/2.2/questions/#{question_ids.join(";")}?order=desc&sort=activity&site=stackoverflow&filter=!E-PH4Kvk4lz6dx697PeHVXbH8._5NUJXUwyenL&auth_token=#{cookies[:stackexg_oauthtoken]}"
		answers    		 = open(answers_query).read
		answers_response = JSON.parse(answers)
		answer_items     = answers_response["items"]
debugger
		q_hash ={}

		answer_items.each_with_index do |a_item,i|
			if !a_item["body"].blank?
				if q_hash[a_item["question_id"]].blank? 
					q_hash[a_item["question_id"]]  = []
				end
				q_hash[a_item["question_id"]] = (q_hash[a_item["question_id"]] << a_item["body"])
			end
		end

		question_ids.each_with_index do |id,i|
			temp_arr = []
			temp_arr << question_titles[i]
			temp_arr << q_hash[id] if !q_hash[id].blank?
			questions << temp_arr
		end
debugger
		return questions
	end
end
