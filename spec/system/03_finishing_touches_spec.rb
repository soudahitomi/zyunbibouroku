require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  let!(:list) { create(:list, post: post) }

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗: nameを0文字にする' do
      before do
        visit new_user_registration_path
        @name = Faker::Lorem.characters(number: 0)
        @email = 'a' + user.email # 確実にuser, other_userと違う文字列にするため
        fill_in 'user[name]', with: @name
        fill_in 'user[email]', with: @email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button '登録する' }.not_to change(User.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button '登録する'
        expect(page).to have_content '新規登録'
        expect(page).to have_field 'user[name]', with: @name
        expect(page).to have_field 'user[email]', with: @email
      end
      it 'バリデーションエラーが表示される' do
        click_button '登録する'
        expect(page).to have_content "is too short (minimum is 1 character)"
      end
    end

    context 'ユーザのプロフィール情報編集失敗: nameを空にする' do
      before do
        @user_old_name = user.name
        visit new_user_session_path
        fill_in 'user[name]', with: @user_old_name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_user_path(user)
        fill_in 'user[name]', with: ''
        click_button '登録'
      end

      it '更新されない' do
        expect(user.reload.name).to eq @user_old_name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: ''
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "is too short (minimum is 1 character)"
      end
    end

    context '投稿データの新規投稿失敗: titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit new_post_path
        fill_in 'post[lists_attributes][0][content]', with: ''
      end

      it '投稿が保存されない' do
        expect { click_button '投稿する' }.not_to change(Post.all, :count)
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('post[title]').text).to be_blank
        expect(page).to have_field 'post[lists_attributes][0][content]', with: ''
      end
      it 'バリデーションエラーが表示される' do
        click_button '投稿する'
        expect(page).to have_content "can't be blank"
      end
    end

    context '投稿データの更新失敗: titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_post_path(post)
        @post_old_title = post.title
        fill_in 'post[title]', with: ''
        click_button '更新する'
      end

      it '投稿が更新されない' do
        expect(post.reload.title).to eq @post_old_title
      end
      it '投稿編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
        expect(find_field('post[title]').text).to be_blank
        expect(page).to have_field 'post[lists_attributes][0][content]', with: list.content
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content '件のエラーが発生しました'
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿一覧画面' do
      visit posts_path
      is_expected.to eq '/users/sign_in'
    end
    it '投稿詳細画面' do
      visit post_path(post)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿編集画面' do
      visit edit_post_path(post)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit post_path(other_post)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + other_post.id.to_s
        end
        it 'ユーザ画像・名前のリンク先が正しい' do
          expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_content other_post.title
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_link '投稿を編集する'
        end
        it '投稿の削除リンクが表示されない' do
          expect(page).not_to have_link '投稿を削除する'
        end
      end
    end

    context '他人の投稿編集画面' do
      let!(:another_user) { create(:user) }
      it '遷移できず、投稿一覧画面にリダイレクトされる' do
        second_user_post = FactoryBot.create(:post, user: user) # 「user」の投稿をもう一つ作成
        sign_in another_user
        visit edit_post_path(second_user_post)
        expect(current_path).to eq '/posts'
      end
    end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '投稿一覧に他人の投稿のtitleが表示され、リンクが正しい' do
          expect(page).to have_link other_post.title, href: post_path(other_post)
        end
      end

      context 'サイドバーの確認' do
        it '他人の名前と紹介文が表示される' do
          expect(page).to have_content other_user.name
        end
        it '他人のフォローユーザーリンクが存在する', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
          expect(page).to have_link '', href: user_followings_path(other_user)
        end
        it '他人のフォロワーユーザーリンクが存在する', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
          expect(page).to have_link '', href: user_followers_path(other_user)
        end
        it '自分の名前と紹介文は表示されない' do
          expect(page).not_to have_content user.name
        end
        it '自分のユーザ編集画面へのリンクは存在しない' do
          expect(page).not_to have_link '', href: edit_user_path(user)
        end
      end
    end

    context '他人のユーザ情報編集画面' do
      it '遷移できず、投稿一覧画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/posts'
      end
    end
  end
end
