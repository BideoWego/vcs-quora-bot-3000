module NamedRangeable
  def self.included(base)
    base.extend(ClassMethods)
  end

  class NamedRange
    attr_reader :key,
                :name,
                :row,
                :col

    def initialize(options={})
      @key = options[:key]
      @name = options[:name]
      @row = options[:row].to_i
      @col = options[:col]
    end
  end

  def named_range(options)
    self.create_named_range(options)
  end

  def named_ranges
    self.class.named_ranges
  end

  def named_ranges=(value)
    self.class.named_ranges = value
  end

  module ClassMethods
    @@subclasses_with_named_ranges = []

    def named_ranges
      @named_ranges
    end

    def named_ranges=(value)
      @named_ranges = value
    end

    def named_range(options)
      self.create_named_range(options)
    end

    def create_named_range(options)
      @named_ranges = {} unless @named_ranges
      @named_ranges[options[:key]] = NamedRange.new(options)
      self.class_eval %Q~
        def #{options[:key]}
          self.class.named_ranges[:#{options[:key]}]
        end
      ~
    end
  end
end

