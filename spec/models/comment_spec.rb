# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { comment.valid? }

    let(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:comment) {  build(:comment, post_id: post.id, user_id: user.id) }

    context 'bodyカラム' do
      it '空欄でないこと', spec_category: "バリデーションとメッセージ表示" do
        comment.body = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×', spec_category: "バリデーションとメッセージ表示" do
        comment.body = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇', spec_category: "バリデーションとメッセージ表示" do
        comment.body = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '140文字以下であること: 140文字は〇', spec_category: "バリデーションとメッセージ表示" do
        comment.body = Faker::Lorem.characters(number: 140)
        is_expected.to eq true
      end
      it '140文字以下であること: 141文字は×', spec_category: "バリデーションとメッセージ表示" do
        comment.body = Faker::Lorem.characters(number: 141)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Comment.reflect_on_association(:notification).macro).to eq :has_one
      end
    end
  end
end
