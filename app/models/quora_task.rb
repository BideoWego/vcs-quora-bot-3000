# --------------------------------------------
# For now I'm putting ideas and mechanize notes here
# --------------------------------------------

class QuoraTask < ScrapeTask
  END_POINT = 'https://www.quora.com/'

  TARGET = '/api/mobile_expanded_voter_list?type=answer&amp;key=oQs9fx3AqQm'

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
