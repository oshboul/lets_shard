class LetsShard
  class Shard
    attr_reader :object, :start_slot, :end_slot
    
    def initialize(object, start_slot, end_slot)
      @object = object
      @start_slot = start_slot
      @end_slot = end_slot
    end
  end
end
