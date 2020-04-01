require 'lets_shard/version'
require 'lets_shard/digest'
require 'lets_shard/shard'

class LetsShard
  attr_reader :shards

  SLOTS = 16384

  def initialize(objects, weights = [])
    validate_parameters!(objects, weights)

    @objects = objects
    @weights = weights.any? ? weights : Array.new(@objects.size, 1)

    set_unit_weight!
    generate_shards!
  end

  def get_shard(key)
    hkey = get_hkey(key)

    @shards.find do |shard|
      (shard.start_slot..shard.end_slot).include?(hkey)
    end
  end

  def get_object(key)
    get_shard(key).object
  end

  private

  def generate_shards!
    @shards = []
    start_slot = 0

    @objects.each_with_index do |object, index|
      end_slot = [start_slot + (@weights[index] * @unit_weight), SLOTS - 1].min

      @shards << Shard.new(object, start_slot, end_slot)

      start_slot = end_slot + 1
    end
  end

  def set_unit_weight!
    @unit_weight = (SLOTS.to_f / @weights.inject(0, :+)).ceil
  end

  def get_hkey(key)
    Digest.crc16(key.to_s) % SLOTS
  end

  def validate_parameters!(objects, weights)
    unless objects.is_a?(Array)
      raise LetsShardError, 'Objects should be an array!'
    end

    unless weights.is_a?(Array)
      raise LetsShardError, 'Weights should be an array!'
    end

    unless objects.any?
      raise LetsShardError, 'Objects array should not be empty!'
    end

    if weights.any? && (objects.size != weights.size)
      raise LetsShardError, 'Weights should be as size as objects!'
    end

    if weights.any? && !weights.all? { |w| w.is_a?(Integer) }
      raise LetsShardError, 'All weights should be integers!'
    end
  end

  class LetsShardError < StandardError; end
end
