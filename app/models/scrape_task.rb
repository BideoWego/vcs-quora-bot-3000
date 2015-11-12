# ------------------------------------
# Wrapper class for a scrape task
# ------------------------------------
# Will refactor later (legacy class from my other projects)

class ScrapeTask
  attr_reader :items

  def initialize(options={})
    @items = options[:items] || {}
    @agent = options[:agent] || Mechanize.new
    @agent.history_added = Proc.new {sleep 1}
  end

  def add(key, message=nil, &block)
    items[key] = block
  end 

  def remove(key)
    items.delete(key)
  end

  def run(agent=nil)
    agent = agent || @agent
    data = {}
    items.each do |key, item|
      data[key] = item.call(agent, data)
    end
    data
  end
end