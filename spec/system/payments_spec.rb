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
      @payment.user.save
    end
    context '新規入力ができるとき' do
      it '全ての情報が正しく入力できている' do
        # ログインを行う
        basic_pass new_user_session_path
        sign_in(@payment.user)
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
        # 入力した内容がトップページに表示されている。
        expect(page).to have_content("￥#{@payment.price}円")
        expect(page).to have_content("#{@payment.registration_date.strftime("%Y-%m-%d")}")
        expect(page).to have_content("カテゴリー:#{@payment.category.name}")
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

RSpec.describe "支払い情報編集", type: :system do
  # メインのユーザー、メインのユーザーのペア登録をするユーザー、ペア登録されていないユーザーを用意
  before do
    @payment1 = FactoryBot.build(:payment)
    @payment1.registration_date = Date.today
    @payment1.save

    @payment2 = FactoryBot.build(:payment)
    @payment2.registration_date = Date.today
    @payment2.save

    @payment3 = FactoryBot.build(:payment)
    @payment3.registration_date = Date.today
    @payment3.save
  end
  context '投稿の編集ができるとき' do
    it 'ログインしたユーザーは自分の投稿した内容を編集できる' do
      # ログインを行う
      basic_pass new_user_session_path
      sign_in(@payment1.user)
    end
  end
end
