require 'rails_helper'

RSpec.describe IconsHelper, type: :helper do
  describe '#fa_icon' do
    subject { helper.fa_icon 'eye' }

    it { is_expected.to eq '<i class="fa fa-eye"></i>' }
  end
end
