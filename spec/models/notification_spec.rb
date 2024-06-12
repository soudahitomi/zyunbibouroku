# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Notification.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end