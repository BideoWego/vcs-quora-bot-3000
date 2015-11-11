class DocsController < ApplicationController

	def index
		client = Google::APIClient.new
		auth = client.authorization
		auth.client_id = ENV["CLIENT_ID"]
		auth.client_secret = ENV["CLIENT_SECRET"]
		auth.scope =
		    "https://www.googleapis.com/auth/drive " +
		    "https://spreadsheets.google.com/feeds/"
		auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
		
		# Creates a session.
		session = GoogleDrive.saved_session()
		
		# First worksheet of
		# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
		spreadsheet = session.spreadsheet_by_key("1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc").worksheets[0]

		# Create an empty array of quora_links
		@quora_links = []
		# Our Google Spreadsheet Links Begin at cell C10 and continue down
		col = 3
		for row in 10..spreadsheet.num_rows
			@quora_links.push(spreadsheet[row, col])
			puts spreadsheet[row, col]
		end
		
	end

end