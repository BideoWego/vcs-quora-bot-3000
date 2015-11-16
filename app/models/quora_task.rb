# --------------------------------------------
# For now I'm putting ideas and mechanize notes here
# --------------------------------------------

class QuoraTask
  attr_accessor :url,
                :page

  def initialize(url)
    @url = url
  	@agent = Mechanize.new
  	@agent.history_added = Proc.new {sleep 1}
  	@agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36'
  	@page = @agent.get(@url)
  end

  def answer_count
  	count = @page.search('.answer_count').inner_text
  	extract_num(count.empty? ? "No Answers Yet" : count)
  end

  def view_count
  	count = @page.search('.QuestionViewsStatsRow').inner_text
  	extract_num(count.empty? ? @page.search('.ViewsRow').inner_text : count)
  end

  def follower_count
  	count = @page.search('.QuestionFollowersStatsRow').inner_text
  	extract_num(count.empty? ? @page.search('.FollowersRow').inner_text.split.first(2).join(' ') : count)
  end

  def last_asked_date
  	asked_date = @page.search('.QuestionLastAskedTime').inner_text 
  	extract_date(asked_date.empty? ? @page.search('.AskedRow').inner_text : asked_date)
  end

  def upvote_count
    # Need to click updated at link
    # Follow to get upvote count on next page
  	# @page.search('.AnswerVoterListModal .modal_title').inner_text

    links = @page.search('.ContentFooter.AnswerFooter a')
    if links.present?
    	href = links.first.attributes['href'].value
    	upvotes_page = @page.links_with(:href => href).first.click
    	extract_num(upvotes_page.search('.AnswerStatsSection .AnswerUpvotesStatsRow').text)
    else
    	"Upvote count not be found"
    end
  end

  def viking_answer_date
    result = @page.search('.ContentFooter.AnswerFooter a[href*=Erik-Trautman]')
    result.present? ? extract_date(result.first.text) : "No Viking Answer"
  end

  def scrape
    data = {}
    data[:url] = @url
    data[:answer_count] = answer_count
    data[:view_count] = view_count
    data[:follower_count] = follower_count
    data[:last_asked_date] = last_asked_date
    data[:upvote_count] = upvote_count
    data[:viking_answer_date] = viking_answer_date
    data
  end

private
	# Return an integer from a string with an integer inside of it
	def extract_num(string)
		if string =~ /\d/
			# This is a strange case that I'd like to account for
			if string == '100+ Answers'
				'100+'
			else
				string.split('').map {|x| x[/\d+/]}.join('')
			end
		else
			string
		end
	end

	# Return a date from a string with a relative date inside of it
	def extract_date(string)
		# We need to make sure there's a potential date in there or 
		# else it could fail
		if string.match(/(\d.*)\s/).present?
			date_string = string.match(/(\d.*)\s/).captures[0]
      if date_string[-1] == 'h'
        date_string.slice!(-1)
        0.days.ago.strftime("%m/%d/%Y")
			elsif date_string[-1] == "d"
				date_string.slice!(-1)
				date_string.to_i.days.ago.strftime("%m/%d/%Y")
			elsif date_string[-1] == "w"
				date_string.slice!(-1)
				date_string.to_i.weeks.ago.strftime("%m/%d/%Y")
			else
				string
			end
		end
	end

  # Named ranges

  # Get Mechanize result
  # agent = Mechanize.new
  # result = agent.get(url)

  # Element locations and classes may differ
  # when NOT logged in to Quora

  # Items to scrape

  # Logged out
  #   view count                  => div.QuestionViewsStatsRow strong
  # 
  #   >  result.search('div.QuestionViewsStatsRow strong').text
  # 
  #   followers                   => div.QuestionStatsSection a.QuestionFollowersStatsRow strong
  # 
  #   >  result.search('div.QuestionStatsSection a.QuestionFollowersStatsRow strong').text
  # 
  #   number of answers           => div.QuestionPageAnswerHeader div.answer_count
  # 
  #   >  result.search('div.QuestionPageAnswerHeader div.answer_count').text
  # 
  # ---- Maybe votes requires login or javascript??? ----
  # 
  #   votes on top answer         => div.AnswerVoterListModal.VoterListModal div.modal_title
  # 
  #    > result.search('.AnswerVoterListModalLink').first #???? <<< MUST CLICK IF NOT LOGGED IN!!!!
  # 
  # 
  #   date question was asked     => div.QuestionLastAskedTime
  # 
  #   >  result.search('div.QuestionLastAskedTime').text
  # 
  # 
  #   viking answer date          => div.ContentFooter.AnswerFooter a[href*=Erik-Trautman]
  # 
  #   >  result.search('div.ContentFooter.AnswerFooter a[href*=Erik-Trautman]').first.text
  # 

  # Logged in
  #   votes on top answer         => div.Answer a.Answer.Upvote.Button span.count
end
