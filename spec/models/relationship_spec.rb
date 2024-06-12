# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rilationshipモデルのテスト', type: :model do
  let(:relationship) { FactoryBot.create(:relationship) }
  describe 'フォローの保存' do
    context 'フォローできる' do
      it 'パラメーターが揃っている' do
        expect(relationship).to be_valid
      end
    end
  end
end