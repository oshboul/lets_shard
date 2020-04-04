require 'lets_shard/version'
require 'lets_shard/digest'
require 'lets_shard/shard'

class LetsShard
  attr_reader :shards

  DEFAULT_SLOTS = 16384

  def initialize(objects, weights: [])
    validate_parameters!(objects, weights)

    @objects = objects
    @weights = weights.any? ? weights : Array.new(@objects.size, 1)
    @slots = @objects.size < DEFAULT_SLOTS ? DEFAULT_SLOTS : @objects.size

    set_unit_weight!
    set_remainder_slots!
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
      end_slot = start_slot + (@weights[index] * @unit_weight) - 1

      if @remainder_slots > 0
        end_slot += 1
        @remainder_slots -= 1
      end

      @shards << Shard.new(object, start_slot, end_slot)

      start_slot = end_slot + 1
    end
  end

  def set_unit_weight!
    @unit_weight = @slots / @weights.inject(0, :+)
  end

  def set_remainder_slots!
    @remainder_slots = @slots - (@unit_weight * @objects.size)
  end

  def get_hkey(key)
    Digest.crc16(key.to_s) % @slots
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
