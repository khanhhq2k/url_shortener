require 'rails_helper'

describe UrlTask::Decoder, aggregate_failures: true do
  it 'decodes encoded url to original url' do
    # original_url = 'https://github.com/donnemartin/system-design-primer#cache'
    url = create(:url) # UrlTask::Encoder.new(original_url).call
    original_url = url.original_url
    encoded_url = "#{ENV['DOMAIN']}/#{url.hash_value}"
    decoded_url = described_class.new(encoded_url).call
    expect(decoded_url).to eq original_url
  end

  context 'When an decoded url is already visited before and persist in cache' do
    it 'returns data from cache and stop querying from Url model' do
      original_url = 'https://github.com/donnemartin/system-design-primer#cache'

      url = create(:url) # UrlTask::Encoder.new(original_url).call
      encoded_url = "#{ENV['DOMAIN']}/#{url.hash_value}"
      described_class.new(encoded_url).call

      described_class.new(encoded_url).call
      expect(Url).not_to receive(:find_by)
    end
  end
end
