
# frozen_string_literal: true
class Stackexg::QuestionsController < Spree::Api::BaseController
	
	DOMAIN="localhost" #it should be automatically configured according to the environment
	SIZE_LIMIT = 10

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
		search_keyword = search_keyword.capitalize
		@results = {}
		@results["Latest #{search_keyword} Questions"]     = get_questions_details search_keyword, "creation", SIZE_LIMIT
		@results["Most Voted #{search_keyword} Questions"] = get_questions_details search_keyword, "votes", SIZE_LIMIT
		debugger
	end

	def redirects
		redirect_to "/get_questions"
	end

	private 
	def get_questions_details search_keyword, sort, size

		require 'open-uri'
		questions_query = "https://api.stackexchange.com/2.2/questions?page=1&pagesize=#{size}&fromdate=1597449600&todate=1598054400&order=desc&sort=#{sort}&tagged=#{search_keyword}&site=stackoverflow&auth_token=#{cookies[:stackexg_oauthtoken]}"
		response        = open(questions_query).read
		json_result     = JSON.parse(response)
		questions       = []
		question_ids    = []
		question_titles = []
		json_result["items"].each_with_index do |item,i|
			question_titles << item["title"].capitalize
			question_ids    << item["question_id"]
		end


		questions_body_query 	 = "https://api.stackexchange.com/2.2/questions/#{question_ids.join(";")}?order=desc&sort=#{sort}&site=stackoverflow&filter=!E-PH4Kvk4lz6dx697PeHVXbH8._5NUJXUwyenL&auth_token=#{cookies[:stackexg_oauthtoken]}"
		questions_body    		 = open(questions_body_query).read
		questions_body_response = JSON.parse(questions_body)
		question_body_items     = questions_body_response["items"]

		q_hash ={}

		question_body_items.each_with_index do |q_item,i|
			if !q_item["body"].blank?
				q_hash[q_item["question_id"]] =  q_item["body"]
			end
		end


		answers_body_query 	 = "https://api.stackexchange.com/2.2/questions/#{question_ids.join(";")}/answers?order=desc&sort=#{sort}&site=stackoverflow&filter=!bM7*SVS)iE1yFX&auth_token=#{cookies[:stackexg_oauthtoken]}"
		answers_body    		 = open(answers_body_query).read
		answers_body_response = JSON.parse(answers_body)
		answer_body_items     = answers_body_response["items"]
		a_hash = {}

		answer_body_items.each_with_index do |a_item,i|
			if !a_item["body"].blank?
				if a_hash[a_item["question_id"]].blank?
					a_hash[a_item["question_id"]] = []
				end
				a_hash[a_item["question_id"]] << a_item["body"]
			end
		end

		question_ids.each_with_index do |id,i|
			temp_arr = []
			temp_arr << question_titles[i]
			if !q_hash[id].blank?
				temp_arr << q_hash[id]
			else
				temp_arr << ""
			end

			if !a_hash[id].blank?
				temp_arr << a_hash[id]
			else
				temp_arr << ""
			end

			questions << temp_arr
		end


		return questions
	end
end
