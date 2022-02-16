require 'rails_helper'


# Basic認証を通すためのメソッド
def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end
# // Basic認証を通すためのメソッド

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      basic_pass root_path
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content("新規登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in '確認のためもう一度パスワードを入力してください', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content("ログアウト")
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻る' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content("新規登録")
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: ''
      fill_in 'Email', with: ''
      fill_in 'パスワード', with: ''
      fill_in '確認のためもう一度パスワードを入力してください', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq('/users')
    end
  end
end


RSpec.describe 'ユーザーログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ユーザーログインができるとき' do
    it '正しい情報を入力すれば、ログインが完了し、トップページに移動する' do
      # トップページに移動
      visit root_path
      # ログインボタンが存在する
      expect(page).to have_content("ログイン")
      # ログインページへ移動する
      visit new_user_session_path
      # ユーザーのログイン情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログイン後のトップページへ移動する
      expect(current_path).to eq root_path
      # 遷移後のページにサインアップ、ログインのリンクが表示されていない
      expect(page).to have_no_content("新規登録")
      expect(page).to have_no_content("ログイン")
      # 遷移後のページに@userの名前が表示されている
      expect(page).to have_content(@user.nickname)
    end
  end
  context 'ログインができないとき' do
    it '誤った内容でログインすると、ログインページに戻る' do
      # トップページに移動
      visit root_path
      # ログインボタンが存在する
      expect(page).to have_content("ログイン")
      # ログインページに移動
      visit new_user_session_path
      # ユーザー情報の入力を行う
      fill_in "Email", with: ''
      fill_in "パスワード", with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに戻されることを確認する
      expect(current_path).to eq('/users/sign_in')
    end
  end
end