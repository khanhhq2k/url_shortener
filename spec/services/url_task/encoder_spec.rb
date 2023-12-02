require 'rails_helper'
describe UrlTask::Encoder, aggregate_failures: true do
  it 'creates new url record' do
    original_url = 'https://github.com/donnemartin/system-design-primer#cache'
    url = described_class.new(original_url).call
    expect(url.original_url).to eq(original_url)
  end

  it 'increases Url record number by 1' do
    original_url = 'https://github.com/donnemartin/system-design-primer#cache'
    expect { described_class.new(original_url).call }.to change { Url.count }.by(1)
  end

  it 'return Url record which has the original url encoded before' do
    original_url = 'https://github.com/donnemartin/system-design-primer#cache'
    url = described_class.new(original_url).call
    url2 = described_class.new(original_url).call
    expect(url.original_url).to eq url2.original_url
    expect(url.hash_value).to eq url2.hash_value
    expect(url.id).to eq url2.id
  end

  context 'When original url is invalid' do
    it 'returns nil for blank url' do
      original_url = ''
      result = described_class.new(original_url).call
      expect(result).to be_nil
    end
    it 'returns nil for nil url' do
      original_url = nil
      result = described_class.new(original_url).call
      expect(result).to be_nil
    end
  end

  context 'receives 2 requests with same original url value' do
    it 'creates only 1 records url' do
      original_url = 'https://github.com/donnemartin/system-design-primer#cache'
      described_class.new(original_url).call
      expect { described_class.new(original_url).call }.to change { Url.count }.by(0)
    end
  end
end
