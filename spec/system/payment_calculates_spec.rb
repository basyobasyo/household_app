require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '精算機能', type: :system do
  before do
    @payment1 = FactoryBot.create(:payment) # メインユーザー
    @payment2 = FactoryBot.create(:payment) # ペアユーザー
    @payment3 = FactoryBot.create(:payment) # 他ユーザー

    @payment1.update(registration_date: Date.today)
    @payment2.update(registration_date: Date.today)

    @user1 = @payment1.user
    @user1.update(pair_id: @payment2.user.id)

    @user2 = @payment2.user
    @user2.update(pair_id: @payment1.user.id)
    # ペア登録した状態
  end
  context '精算ができる' do
    it 'ペアが登録されている状態で、支払い情報が存在する' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 精算ページへ移動するリンクが存在する
      expect(page).to have_link '精算ページへ', href: calculate_page_payments_path
      # 精算ページに移動する
      visit calculate_page_payments_path
      # 日付を入力する(日付の期間は１ヶ月前〜本日とする)
      fill_in 'date_from', with: (Date.today - 30)
      fill_in 'date_to', with: @payment1.registration_date
      # 精算ボタンを押す
      find('input[name="commit"]').click
      # 精算結果表示ページへ遷移していることを確認
      expect(current_path).to eq calculate_result_payments_path
      # 精算結果が表示されている
      expect(page).to have_content "精算結果出力ページ"
    end
  end
  context '精算ができないとき' do
    it 'ペア登録状態でも、期間の指定が誤っていると精算できない(日付フォームが空)' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 精算ページへ移動するリンクが存在する
      expect(page).to have_link '精算ページへ', href: calculate_page_payments_path
      # 精算ページに移動する
      visit calculate_page_payments_path
      # 日付を入力せずに精算を行う
      find('input[name="commit"]').click
      # 精算ページにrenderされ、エラーメッセージが表示されている
      expect(page).to have_content "精算ページ"
      expect(page).to have_content '精算を行うことができませんでした。値が空では精算ができません。'
    end
    it 'ペア登録状態でも、期間の指定が誤っていると精算できない(日付の時系列が逆)' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 精算ページへ移動するリンクが存在する
      expect(page).to have_link '精算ページへ', href: calculate_page_payments_path
      # 精算ページに移動する
      visit calculate_page_payments_path
      # 日付を入力する(日付の時系列は逆にする)
      fill_in 'date_from', with: @payment1.registration_date
      fill_in 'date_to', with: (Date.today - 30)
      # 精算を行う
      find('input[name="commit"]').click
      # 精算ページに遷移し、エラーメッセージが表示されている
      expect(page).to have_content "精算ページ"
      expect(page).to have_content "精算を行うことができませんでした。正しく値を入力して下さい。"
    end
    it 'ペア登録していない場合は精算ができない' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment3.user)
      # 精算ページへのリンクがトップページに存在しない
      expect(page).to have_no_link '精算ページへ', href: calculate_page_payments_path
      # 精算ページへアクセスすると、トップページへ遷移する
      visit calculate_page_payments_path
      expect(current_path).to eq root_path
    end
  end
end