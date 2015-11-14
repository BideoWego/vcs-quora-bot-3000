# --------------------------------------------
# For now I'm putting ideas and mechanize notes here
# --------------------------------------------

class QuoraTask < ScrapeTask
  attr_accessor :url,
                :page

  def initialize(url)
    @url = url
  	@agent = Mechanize.new
  	@agent.history_added = Proc.new {sleep 1}
  	@agent.user_agent_alias = 'Mac Safari'
  	@page = @agent.get(@url)
  end

  def answer_count
  	@page.search('.answer_count').inner_text
  end

  def view_count
  	@page.search('.QuestionViewsStatsRow').inner_text
  end

  def follower_count
  	@page.search('.QuestionFollowersStatsRow').inner_text
  end

  def last_asked_date
  	@page.search('.QuestionLastAskedTime').inner_text
  end

  def upvote_count
    # Need to click updated at link
    # Follow to get upvote count on next page
  	# @page.search('.AnswerVoterListModal .modal_title').inner_text

    links = @page.search('.ContentFooter.AnswerFooter a')
    if links.present?
    	href = links.first.attributes['href'].value
    	upvotes_page = @page.links_with(:href => href).first.click
    	upvotes_page.search('.AnswerStatsSection .AnswerUpvotesStatsRow').text
    else
    	"Upvote count not found"
    end
  end

  def viking_answer_date
    result = @page.search('.ContentFooter.AnswerFooter a[href*=Erik-Trautman]')
    result.present? ? result.first.text : "No Viking Answer"
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
