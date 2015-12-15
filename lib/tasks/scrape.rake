# ------------------------------------
# Output a header in the console
# ------------------------------------
def console_header(str)
  width = 20
  delimiter = '-' * width
  puts delimiter
  puts str.center(width)
  puts delimiter
end

namespace :scrape do

  # ------------------------------------
  # Run the scrape
  # ------------------------------------
  # 
  # Run with:
  #   $ rake scrape:quora
  # 
  desc 'Scrapes Quora with the most recently created Spreadsheet and Scrape'
  task :quora => :environment do
    
    console_header('Scraping')

    data = {}
    
    # Get most recent spreadsheet
    puts 'Getting most recent spreadsheet'
    spreadsheet = Spreadsheet.order(:created_at => 'DESC').first

    # If we have a spreadsheet
    if spreadsheet

      # Get it's urls
      puts 'Reading scrape target URLs from spreadsheet'
      urls = spreadsheet.generate_urls
      total = urls.length
      puts "Found #{total} URLs"

      # Scrape each url
      urls.each_with_index do |quora_url, i|
        puts "Scraping #{i + 1} of #{total} urls"
        data[quora_url] = QuoraTask.new(quora_url).scrape
      end

      # Get most recent scrape and set it's data
      puts 'Saving data'
      scrape = spreadsheet.scrapes.order(:created_at => 'DESC').first
      scrape.data = data

      # Save with success message
      if scrape.save!
        puts "Scrape successful!"
      else
        puts "Error saving scrape"
      end
    else

      # Spreadsheets is probably empty
      puts 'No spreadsheet found, do any exist?'
    end
  end

  # ------------------------------------
  # Upload the scrape
  # ------------------------------------
  # 
  # Run with:
  #   $ rake scrape:upload
  # 
  desc 'Uploads the most recently scraped data'
  task :upload => :environment do
    console_header('Uploading')

    # Get most recently updated scrape
    puts 'Getting most recent scrape'
    scrape = Scrape.order(:updated_at => 'DESC').first

    # Get spreadsheet
    puts 'Getting scrape spreadsheet'
    spreadsheet = scrape.spreadsheet

    # Upload data
    puts 'Uploading scrape data'
    if spreadsheet.upload(scrape.id)

      # Show success
      puts "Data uploaded to Spreadsheet:"
      puts "  KEY #{spreadsheet.key}"
      puts "  GID: #{spreadsheet.data_gid}"
      puts "See results at:\n"
      puts "  #{spreadsheet.data_worksheet.human_url}\n"
    else

      # Or error
      puts 'There was a problem with the upload'
    end
    puts 'Done!'
  end

  # ------------------------------------
  # Run scrape and upload
  # ------------------------------------
  # 
  # Run with:
  #   $ rake scrape:auto
  # 
  desc 'Runs scrape:quora and then scrape:upload'
  task :auto => :environment do
    Rake::Task['scrape:quora'].invoke
    Rake::Task['scrape:upload'].invoke
  end
end


