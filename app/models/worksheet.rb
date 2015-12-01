class Worksheet
  ALPHA = ('a'..'z').to_a

  attr_accessor :spreadsheet,
                :internal_worksheet

  # Initialize the worksheet with
  # a reference to it's parent spreadsheet
  # and it's internal API worksheet
  def initialize(attributes={})
    @spreadsheet = attributes[:spreadsheet]
    @internal_worksheet = attributes[:worksheet]
  end

  # Override @internal_worksheet []=
  # to provide functionality to convert
  # 
  def [](*args)
    array_index_accessor(*args)
  end

  # Override @internal_worksheet []=
  # to provide functionality to convert
  # 
  def []=(*args)
    array_index_accessor(*args)
  end

  # Get a range of rows and columns
  def range(row_range, col_range)
    col_range = Worksheet.alpha_to_numeric_range(col_range)
    range = []
    row_range.each do |row|
      range_row = []
      col_range.each do |col|
        range_row << @internal_worksheet[row, col]
      end
      range << range_row
    end
    range
  end

  # Forwards any missing methods
  # to the @internal_worksheet object
  # only if it responds to the method
  def method_missing(name, *args)
    if @internal_worksheet.respond_to?(name)
      args.length > 0 ? @internal_worksheet.send(name, args) : @internal_worksheet.send(name)
    else
      raise NoMethodError, "Undefined method #{name} for Worksheet"
    end
  end

  # Reverses a column index to a letter string
  def self.letters_for(col_index)
    str = ''
    if col_index >= 1
      quotient = col_index
      while quotient > 0
        quotient, remainder = (quotient - 1).divmod(26)
        str.prepend(ALPHA[remainder])
      end
    end
    str
  end

  # Returns the integer index for
  # a given column's letter(s)
  def self.col_index_for(letters)
    index = 0
    letters.downcase!
    (1..letters.length).each do |i|
      char = letters[-i]
      index += 26**(i - 1) * (ALPHA.index(char) + 1)
    end
    index
  end


  protected
  def self.alpha_to_numeric_range(alpha_range)
    if alpha_range.first.is_a?(String)
      numeric_range_first = Worksheet.col_index_for(alpha_range.first)
      numeric_range_last = Worksheet.col_index_for(alpha_range.last)
      numeric_range_first..numeric_range_last
    else
      alpha_range
    end
  end


  private
  def array_index_accessor(*args)
    if [2, 3].include?(args.length)
      row = args[0]
      col = args[1]
      col = Worksheet.col_index_for(col) if col.is_a?(String)
      if args.length == 3
        @internal_worksheet[row, col] = args[2]
      else
        @internal_worksheet[row, col]
      end
    elsif args.length == 1
      @internal_worksheet[args[0]]
    else
      raise ArgumentError, "expected 1..3 args, got: #{args.length}"
    end
  end
end




