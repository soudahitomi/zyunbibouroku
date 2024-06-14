require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
    end

    context 'サイドバーの確認 左側' do
      it '自分の名前が表示される' do
        expect(page).to have_content user.name
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path
      end
      it '通知一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: notifications_path
      end
      it 'いいね一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: favorites_user_path(user)
      end
      it 'フォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
      it 'フォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
    end
  end#投稿一覧画面のテスト

  describe '投稿画面のテスト' do
    before do
      visit new_post_path
      fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
      #fill_in 'list[content]', with: Faker::Lorem.characters(number: 20)
    end

    context '投稿成功のテスト' do
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿する' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/posts'
      end
    end
  end#投稿画面のテスト'

  describe '自分の投稿詳細画面のテスト' do
    before do#2ここで投稿の情報とかって入れないの？
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      # it '投稿のlistが表示される' do
      #   expect(page).to have_content list.content
      # end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '投稿を編集する', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '投稿を削除する', href: post_path(post)
      end
    end

    context 'サイドバーの確認 左側' do
      it '自分の名前が表示される' do
        expect(page).to have_content user.name
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '投稿画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_post_path
      end
      it '通知一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: notifications_path
      end
      it 'いいね一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: favorites_user_path(user)
      end
      it 'フォロー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followings_path(user)
      end
      it 'フォロワー一覧画面へのリンクが存在する' do
        expect(page).to have_link '', href: user_followers_path(user)
      end
    end
# kokokara
    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        second_user_post = FactoryBot.create(:post, user: user)
        visit post_path(second_user_post)
        click_link '投稿を編集する'
        expect(current_path).to eq edit_post_path(second_user_post)
      end
    end

    context '削除リンクのテスト' do
      it 'application.html.erbにjavascript_pack_tagを含んでいる' do
        is_exist = 0
        open("app/views/layouts/application.html.erb").each do |line|
          strip_line = line.chomp.gsub(" ", "")
          if strip_line.include?("<%=javascript_pack_tag'application','data-turbolinks-track':'reload'%>")
            is_exist = 1
            break
          end
        end
        expect(is_exist).to eq(1)
      end
      before do
        click_link '投稿を削除する'
      end
      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/posts'
      end
    end
  end#自分の投稿詳細画面のテスト
# korekesu
  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_book_path(book)
    end

    context '表示の確認' do
      it 'URLが正しい', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/books/' + book.id.to_s + '/edit'
      end
      it '「Editing Book」と表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_content 'Editing Book'
      end
      it 'title編集フォームが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_field 'book[title]', with: book.title
      end
      it 'body編集フォームが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_field 'book[body]', with: book.body
      end
      it 'Update Bookボタンが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_button 'Update Book'
      end
      it 'Showリンクが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_link 'Show', href: book_path(book)
      end
      it 'Backリンクが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_link 'Back', href: books_path
      end
    end

    context '編集成功のテスト' do
      before do
        @book_old_title = book.title
        @book_old_body = book.body
        fill_in 'book[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'book[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update Book'
      end

      it 'titleが正しく更新される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(book.reload.title).not_to eq @book_old_title
      end
      it 'bodyが正しく更新される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(book.reload.body).not_to eq @book_old_body
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/books/' + book.id.to_s
        expect(page).to have_content 'Book detail'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(all('img').size).to eq(3)
      end
      it '自分と他人の名前がそれぞれ表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_link 'Show', href: user_path(user)
        expect(page).to have_link 'Show', href: user_path(other_user)
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '「New book」と表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content 'New book'
      end
      it 'titleフォームが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_field 'book[title]'
      end
      it 'titleフォームに値が入っていない', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(find_field('book[title]').text).to be_blank
      end
      it 'bodyフォームが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_field 'book[body]'
      end
      it 'bodyフォームに値が入っていない', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(find_field('book[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_button 'Create Book'
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_link book.title, href: book_path(book)
      end
      it '投稿一覧に自分の投稿のbodyが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content book.body
      end
      it '他人の投稿は表示されない', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_book.title
        expect(page).not_to have_content other_book.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '「New book」と表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_content 'New book'
      end
      it 'titleフォームが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_field 'book[title]'
      end
      it 'titleフォームに値が入っていない', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(find_field('book[title]').text).to be_blank
      end
      it 'bodyフォームが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_field 'book[body]'
      end
      it 'bodyフォームに値が入っていない', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(find_field('book[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(page).to have_button 'Create Book'
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_button 'Update User'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        expect(user.profile_image).to be_attached
        click_button 'Update User'
        save_page
      end

      it 'nameが正しく更新される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end
