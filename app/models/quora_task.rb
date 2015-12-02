class QuoraTask
  attr_accessor :url,
                :page

  attr_reader :data

  def initialize(url)
    @url = url
    @agent = Mechanize.new
    @agent.history_added = Proc.new {sleep 1}
    @page = @agent.get(@url)
  end

  def answer_count
    count = @page.search(css[:answer_count]).text
    count.empty? ? 'No answer count' : extract_num(count)
  end

  def view_count
    count = @page.search(css[:view_count]).text
    count.empty? ? 'No view count' : extract_num(count)
  end

  def follower_count
    count = @page.search(css[:follower_count]).text
    count.empty? ? 'No follower count' : extract_num(count)
  end

  def last_asked_date
    asked_date = @page.search(css[:last_asked_date]).text
    asked_date.empty? ? 'Last asked date not found' : extract_date(asked_date)
  end

  def upvote_count
    upvotes_page = page_from_upvotes_link
    if upvotes_page
      count = upvotes_page.search(css[:upvote_count]).text
      extract_num(count)
    else
      'Upvote count not be found'
    end
  end

  def viking_answer_date
    result = @page.search(css[:viking_answer_date])
    result.empty? ? 'No Viking Answer' : extract_date(result.first.text)
  end

  def scrape
    @data = {
      :question_url => @url,
      :answer_count => answer_count,
      :view_count => view_count,
      :follower_count => follower_count,
      :last_asked_date => last_asked_date,
      :upvote_count => upvote_count,
      :viking_answer_date => viking_answer_date
    }
  end


  private
  def extract_num(string)
    matches = string.match(/[\d,]+\+?/)
    if matches
      string = matches[0]
      string.gsub(',', '')
    else
      string
    end
  end

  def extract_date(string)
    string = ensure_consistent_date_format(string)
    matches = string.match(/\d{1,2} [a-zA-Z]{3} ?\d{0,4}/)
    if matches
      formatted_date_to_numeric(matches[0])
    else
      string
    end
  end

  def ensure_consistent_date_format(string)
    string = day_abbr_to_full_date(string)
    append_year_if_absent(string)
  end

  def day_abbr_to_full_date(string)
    day = string.strip[-3..-1]
    if Date::ABBR_DAYNAMES.include?(day)
      target_day = Date.today
      while target_day.strftime('%a') != day
        target_day = target_day.prev_day
      end
      day_and_month = target_day.strftime('%e %b')
      string.gsub!(day, day_and_month)
    end
    string
  end

  def append_year_if_absent(string)
    string += " #{Date.today.year.to_s}" unless string =~ /\d{4}/
    string
  end

  def formatted_date_to_numeric(date)
    date_segments = date
    date_segments = date_segments.split(' ')
    date_segments.map do |date_segment|
      date_segment =~ /\d/ ? date_segment : Date::ABBR_MONTHNAMES.index(date_segment).to_s
    end.join('/')
  end

  def css
    {
      :answer_count => 'div.QuestionPageAnswerHeader .answer_count',
      :link_to_upvote_count => '.ContentFooter.AnswerFooter a',
      :upvote_count => '.AnswerStatsSection .AnswerUpvotesStatsRow',
      :viking_answer_date => '.ContentFooter.AnswerFooter a[href*=Erik-Trautman]'
    }.merge(@page.search('.HighlightsSection').empty? ? safari_css : chrome_css)
  end

  def safari_css
    {
      :view_count => 'div.QuestionStatsSection .QuestionViewsStatsRow strong',
      :follower_count => 'div.QuestionStatsSection .QuestionFollowersStatsRow strong',
      :last_asked_date => 'div.QuestionFollowersList .QuestionLastAskedTime'
    }
  end

  def chrome_css
    {
      :view_count => 'div.SignupColumn .ViewsRow',
      :follower_count => '.FollowersRow',
      :last_asked_date => '.HighlightsSection.SimpleToggle.Toggle.hidden .AskedRow'
    }
  end

  def page_from_upvotes_link
    links = @page.search(css[:link_to_upvote_count])
    if links.present?
      href = links.first.attributes['href'].value
      @page.links_with(:href => href).first.click
    end
  end
end


