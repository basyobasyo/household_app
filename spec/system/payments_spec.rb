require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "支払い情報投稿", type: :system do
    before do
      @payment = FactoryBot.build(:payment)
      # トップページに表示させるため、本日の日付にする。
      @payment.registration_date = Date.today
      @payment.save
    end
    context '新規入力ができるとき' do
      it '全ての情報が正しく入力できている' do
        # ログインを行う
        basic_pass new_user_session_path
        visit new_user_session_path
        fill_in "Email", with: @payment.user.email
        fill_in "パスワード", with: @payment.user.password
        find('input[name="commit"]').click
        # ログイン後にトップページに移動していることの確認
        expect(current_path).to eq root_path
        # トップページに「新規入力画面へ」のリンクがある
        expect(page).to have_content("新規入力画面へ")
        # 新規入力画面へ移動する
        visit new_payment_path
        # 新規情報を入力する
        fill_in "支払い金額を入力してください", with: @payment.price
        fill_in "payment_registration_date", with: @payment.registration_date
        select "#{@payment.category.name}", from: 'payment[category_id]'
        fill_in "備考があれば入力してください", with: @payment.memo
        # 新規投稿のボタンを押す
        expect{
          find('input[name="commit"]').click
        }.to change{Payment.count}.by(1)
        # 投稿後はトップページに戻る。
        expect(current_path).to eq root_path
      end
    end
    context '新規投稿できないとき' do
      it 'ログインしていないと新規投稿できない' do
        # トップページへ移動する
        visit root_path
        # 新規投稿ページがないことを確認
        expect(page).to have_no_content("新規入力画面へ")
        # ログインしていなければ、直接投稿ページへ移動できず、ログイン画面へ遷移
        visit new_payment_path
        expect(current_path).to eq new_user_session_path
      end
    end
end
