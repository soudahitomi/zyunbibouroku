# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { list.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'contentカラム' do
      it '50文字以下であること: 50文字は〇' do
        list.content = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×' do
        list.content = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(List.reflect_on_association(:post).macro).to eq :has_many
      end
    end
  end
end