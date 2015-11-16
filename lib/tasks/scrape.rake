namespace :scrape do
	task :quora => :environment do
		data = {}
		Spreadsheet.all.each do |spreadsheet|
			temp_spreadsheet = Spreadsheet.find(spreadsheet.id)
	    all_urls = temp_spreadsheet.generate_urls
	    total = all_urls.length
	    all_urls.each_with_index do |quora_url, i|
	      puts "Scraping #{i + 1} of #{total} urls"
	    	data[quora_url] = QuoraTask.new(quora_url).scrape
	    end
	    scrape = spreadsheet.scrapes.first
	    scrape.data = data
	    if scrape.save!
	    	puts "Scrape successful!"
	    else
	    	puts "Error saving scrape"
	    end
		end
	end
end