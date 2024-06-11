# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { list.valid? }
    let(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:list) {  build(:list, post_id: post.id) }
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:list,post_id: post.id, content: Faker::Lorem.characters(number: 50))).to be_valid
    end

    context 'contentカラム' do
      it '50文字以下であること: 50文字は〇',spec_category: "バリデーションとメッセージ表示" do
        list.content = Faker::Lorem.characters(number: 30)
        pp list
        pp is_expected
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×',spec_category: "バリデーションとメッセージ表示" do
        list.content = Faker::Lorem.characters(number: 51)
        pp is_expected
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(List.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end