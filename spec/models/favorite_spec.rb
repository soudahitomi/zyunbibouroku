# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Favoriteモデルのテスト', type: :model do
  subject { favorite.valid? }
    let(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:favorite) {  build(:favorite, post_id: post.id, user_id: user.id) }

  describe 'いいね機能' do
    context 'いいねできる場合' do
      it "user_idとpost_idがあれば保存できる" do
        expect(favorite).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:notification).macro).to eq :has_one
      end
    end
  end
end