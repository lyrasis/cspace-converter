require 'rails_helper'

RSpec.describe CSDH do

  describe '#.split_value' do
    it 'splits value correctly' do
      result = CSDH.split_value('2015/11/15; 2015/11/17')
      expect(result).to eq(['2015/11/15', '2015/11/17'])
    end
  end
  
end
