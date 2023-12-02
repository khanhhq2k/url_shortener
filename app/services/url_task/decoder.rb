class UrlTask::Decoder
  attr_reader :hash_value

  def initialize(encoded_url)
    @hash_value = get_hash_value(encoded_url)
  end

  def call
    return unless hash_value.present?
    decode
  end

  private

  def decode
    cached_url = Cache.new.get(hash_value)
    return cached_url if cached_url
    url = Url.find_by(hash_value: hash_value)
    return unless url
    Cache.new.set(hash_value, url.original_url)
    url.original_url
  end

  def get_hash_value encoded_url
    url = URI(encoded_url)
    path = url.path
    path.slice!(0) #remove "/" to get hash_value
    path
  end


end

