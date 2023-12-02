require 'rails_helper'
describe Cache, aggregate_failures: true do
  describe 'set cache' do
    before do
      Rails.cache.clear
    end

    it 'saves key value to cache' do
      cache_instance = described_class.new
      cache_instance.set('ABC1F', 'test_url')

      expect(cache_instance.hash_values.size).to eq(1)
    end

    context 'when caching is reach limit' do
      it 'removes last element from cache and move latest element to top of list' do
        cache_instance = described_class.new

        key = 'ABCDE'
        value = 'test_url_1'
        key2 = 'ABCDF'
        value2 = 'test_url_2'
        described_class::MAX_SIZE.times do | i |
         cache_instance.set("#{key}_#{i}", value) #for uniqueness of keys
        end
        cache_instance.set(key2, value2)

        expect(cache_instance.hash_values.length).to eq(described_class::MAX_SIZE)
        expect(cache_instance.hash_values.first).to eq(key2)
      end
    end
  end

  describe 'get cache' do
    it 'returns a value which have key in cache' do
      cache_instance = described_class.new
      cache_instance.set('Khanh', 'Nguyen')
      cache_instance.set('ABCDEF', 'GHIKML')

      expect(cache_instance.get('Khanh')).to eq 'Nguyen'
      expect(cache_instance.get('ABCDEF')).to eq 'GHIKML'
    end

    it 'moves selected element to index 0' do
      cache_instance = described_class.new

      2.times { cache_instance.set('Khanh', 'Nguyen') }
      4.times { cache_instance.set('ABCDEF', 'GHIKML') }
      expect(cache_instance.hash_values.first).to eq 'ABCDEF'
      expect { cache_instance.get('Khanh') }.to change { cache_instance.hash_values.first }.from('ABCDEF').to('Khanh')
    end
  end
end
