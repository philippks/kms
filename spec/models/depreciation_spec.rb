require 'rails_helper'

describe Depreciation, type: :model do
  let(:activity) { create :activity, :with_associations }

  describe 'create' do
    it 'changes state of assigned activities' do
      expect do
        create :depreciation, efforts: [activity]
      end.to change(activity, :state).from('open').to('depreciated')
    end
  end
end
