class UrlTask::Encoder
  attr_reader :original_url, :counter_number

  RANDOM_RANGE = 10_000_000_000
  def initialize(original_url)
    # a Unique id must be generated in order to achive unique hash_value and prevent collision, as the hash value lenght
    # is must be less than 6, as 5, so for base62 encoding, we will have
    # 62^5 = 916 132 832 unique hash_value possible, so a random number which is less than 1 Billion is enough
    # this is for quick demonstration purpose, in real project we should rely on real unique number(Primary key id of url record for example...)
    @counter_number = SecureRandom.random_number(RANDOM_RANGE)
    @original_url = original_url
  end

  def call
    return unless original_url.present?
    if Url.where(original_url: original_url).exists?
      return Url.find_by(original_url: original_url)
    end
    create_url
  end

  private

  def create_url
    url_hash_encoded = generate_unique_hash
    url = Url.create(
      hash_value: url_hash_encoded,
      original_url: original_url,
      expired_at: DateTime.now + 1.year
    )
  end

  # 916_000_000.base62_encode
  # => "zzRRY".length == 5
  # 917_000_000.base62_encode
  # => "103daa".length == 6
  def generate_unique_hash
    url_md5_digest = md5_hash[0..6] #choose the range 0..6 to generate a number less than 1 Billion
    integer_number = url_md5_digest.hex
    integer_number.base62_encode
  end

  def md5_hash
    url = original_url + counter_number.to_s
    Digest::MD5.hexdigest(url)
  end
end


