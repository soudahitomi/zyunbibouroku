# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと', spec_category: "バリデーションとメッセージ表示" do
        user.name = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×', spec_category: "バリデーションとメッセージ表示" do
        user.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇', spec_category: "バリデーションとメッセージ表示" do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '30文字以下であること: 30文字は〇', spec_category: "バリデーションとメッセージ表示" do
        user.name = Faker::Lorem.characters(number: 30)
        is_expected.to eq true
      end
      it '30文字以下であること: 31文字は×', spec_category: "バリデーションとメッセージ表示" do
        user.name = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
      it '一意性があること', spec_category: "バリデーションとメッセージ表示" do
        user.name = other_user.name
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end
