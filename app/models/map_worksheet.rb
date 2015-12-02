class MapWorksheet < Worksheet
  FIRST_ROW = 1

  named_range :key => :key,
              :name => 'Key Name',
              :col => 'a',
              :row => FIRST_ROW

  named_range :key => :name,
              :name => 'Name',
              :col => 'b',
              :row => FIRST_ROW

  named_range :key => :column,
              :name => 'Column',
              :col => 'c',
              :row => FIRST_ROW

  named_range :key => :row,
              :name => 'Row',
              :col => 'd',
              :row => FIRST_ROW

  attr_reader :keys,
              :names,
              :columns,
              :rows,
              :entries

  def initialize(attributes={})
    super(attributes)
    populate_attributes
  end

  def refresh
    populate_attributes
  end


  private
  def populate_attributes
    @keys = range(
      key.row.next..num_rows,
      key.col
    ).flatten.map(&:to_sym)

    @names = range(
      name.row.next..num_rows,
      name.col
    ).flatten

    @columns = range(
      column.row.next..num_rows,
      column.col
    ).flatten

    @rows = range(
      row.row.next..num_rows,
      row.col
    ).flatten

    @entries = []
    (num_rows - FIRST_ROW).times do |row_num|
      @entries << {
        :key => @keys[row_num],
        :name => @names[row_num],
        :col => @columns[row_num],
        :row => @rows[row_num]
      }
    end
  end
end



