# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと', spec_category: "バリデーションとメッセージ表示" do
        post.title = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×', spec_category: "バリデーションとメッセージ表示" do
        post.title = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇', spec_category: "バリデーションとメッセージ表示" do
        post.title = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '50文字以下であること: 50文字は〇', spec_category: "バリデーションとメッセージ表示" do
        post.title = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×', spec_category: "バリデーションとメッセージ表示" do
        post.title = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Listモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:lists).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'Notificationsモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end
