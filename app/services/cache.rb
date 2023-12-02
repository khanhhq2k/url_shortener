class Cache
  attr_reader :objects, :hash_values
  MAX_SIZE = 50

  def initialize
    @objects = Rails.cache.read('least_recently_used') || {}
    @hash_values = Rails.cache.read('hash_values') || [] # a list of shortener 
  end

  def set(key, value)
    @objects[key] = value
    set_hash_values(key) #move this key to first of the list
    @objects.delete(@hash_values.pop) if @hash_values.size > MAX_SIZE # Delete the last key pair from object if
    #persist to rails cache
    Rails.cache.write('least_recently_used', @objects)
    Rails.cache.write('hash_values', @hash_values)
  end

  def get(key)
    if @objects[key]
      set_hash_values(key)
      Rails.cache.write('hash_values', @hash_values) #if cache hit, just move the hash_value to top of list
      @objects[key]
    end
  end

  private
  def set_hash_values(key)
    @hash_values.unshift(@hash_values.delete(key) || key)
  end
end

