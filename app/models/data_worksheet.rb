class DataWorksheet < Worksheet
  attr_reader :question_urls,
              :last_asked_dates,
              :view_counts,
              :follower_counts,
              :answer_counts,
              :upvote_counts,
              :viking_answer_dates

  # Thank you: http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
  URL_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/

  def refresh
    populate_attributes
  end

  def write(data)
    sanitized_urls.each_with_index do |url, i|
      if data[url]
        row = question_url.row.next + i
        self[row, last_asked_date.col] = data[url]['last_asked_date']
        self[row, view_count.col] = data[url]['view_count']
        self[row, follower_count.col] = data[url]['follower_count']
        self[row, answer_count.col] = data[url]['answer_count']
        self[row, upvote_count.col] = data[url]['upvote_count']
        self[row, viking_answer_date.col] = data[url]['viking_answer_date']
      end
    end
    save
  end

  def sanitized_urls
    @question_urls.select {|str| str.match(URL_REGEX)}
  end

  def create_named_ranges(map_worksheet)
    self.class.create_named_ranges(map_worksheet)
    populate_attributes
  end

  def self.create_named_ranges(map_worksheet)
    map_worksheet.entries.each do |options|
      DataWorksheet.named_range(options)
    end
  end


  private
  def populate_attributes
    @question_urls = range(
      question_url.row.next..num_rows,
      question_url.col
    ).flatten

    @last_asked_dates = range(
      last_asked_date.row.next..num_rows,
      last_asked_date.col
    ).flatten

    @view_counts = range(
      view_count.row.next..num_rows,
      view_count.col
    ).flatten

    @follower_counts = range(
      follower_count.row.next..num_rows,
      follower_count.col
    ).flatten

    @answer_counts = range(
      answer_count.row.next..num_rows,
      answer_count.col
    ).flatten

    @upvote_counts = range(
      upvote_count.row.next..num_rows,
      upvote_count.col
    ).flatten

    @viking_answer_dates = range(
      viking_answer_date.row.next..num_rows,
      viking_answer_date.col
    ).flatten
  end
end

