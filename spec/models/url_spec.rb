require 'rails_helper'

RSpec.describe Url, type: :model do
  it "is not valid with duplicated hash_value" do
    original_url = "https://github.com/donnemartin/system-design-primer#cache"
    url = UrlTask::Encoder.new(original_url).call
    invalid_url = Url.new(
      hash_value: url.hash_value,
      original_url: original_url,
      expired_at: DateTime.now + 1.year
    )
    expect(invalid_url).to_not be_valid
  end

end
