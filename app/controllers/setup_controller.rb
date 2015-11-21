class SetupController < ApplicationController

	def setup
		if params[:client_id] && params[:client_secret]
			client = Google::APIClient.new
			auth = client.authorization
			auth.client_id = params[:client_id]
			auth.client_secret = params[:client_secret]
			auth.scope =
			    "https://www.googleapis.com/auth/drive " +
			    "https://spreadsheets.google.com/feeds/"
			auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
			print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
			print("2. Enter the authorization code shown in the page: ")
			auth.code = $stdin.gets.chomp
			@token = auth.fetch_access_token!
			access_token = auth.access_token
		end
		check_token_data
	end

private
	
	def check_token_data
		if !@token.nil? && @token["refresh_token"] && @token["refresh_token"].length > 0
			@refresh_token = @token["refresh_token"]
		end
	end
end