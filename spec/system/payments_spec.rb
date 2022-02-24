require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '支払い情報投稿', type: :system do
  before do
    @payment = FactoryBot.build(:payment)
    # トップページに表示させるため、本日の日付にする。
    @payment.registration_date = Date.today
    @payment.user.save
  end
  context '新規入力ができるとき' do
    it '全ての情報が正しく入力できている' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment.user)
      # トップページに「新規入力画面へ」のリンクがある
      expect(page).to have_content('新規入力画面へ')
      # 新規入力画面へ移動する
      visit new_payment_path
      # 新規情報を入力する
      fill_in '支払い金額を入力してください', with: @payment.price
      fill_in 'payment_registration_date', with: @payment.registration_date
      select @payment.category.name.to_s, from: 'payment[category_id]'
      fill_in '備考があれば入力してください', with: @payment.memo
      # 新規投稿のボタンを押す
      # 投稿の件数が増える
      expect  do
        find('input[name="commit"]').click
      end.to change { Payment.count }.by(1)
      # 投稿後はトップページに戻る。
      expect(current_path).to eq root_path
      # 入力した内容がトップページに表示されている。
      expect(page).to have_content("￥#{@payment.price}円")
      expect(page).to have_content(@payment.registration_date.strftime('%Y-%m-%d').to_s)
      expect(page).to have_content("カテゴリー:#{@payment.category.name}")
    end
  end
  context '新規投稿できないとき' do
    it 'ログインしていないと新規投稿できない' do
      # トップページへ移動する
      visit root_path
      # 新規投稿ページがないことを確認
      expect(page).to have_no_content('新規入力画面へ')
      # ログインしていなければ、直接投稿ページへ移動できず、ログイン画面へ遷移
      visit new_payment_path
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe '支払い情報編集', type: :system do
  # メインのユーザー、メインのユーザーのペア登録をするユーザー、ペア登録されていないユーザーを用意
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

    @sample = FactoryBot.build(:payment)
  end
  context '投稿の編集ができるとき' do
    it 'ログインしたユーザーは自分の投稿した内容を編集できる' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 編集アイコンをクリック
      all('.right-content-icon')[0].click
      # ログインユーザーが投稿した項目に編集ボタンがある
      expect(page).to have_link '編集', href: edit_payment_path(@payment1)
      # 編集ページへ移動する
      visit edit_payment_path(@payment1)
      # 既に投稿した内容が入力されている
      expect(
        find('input[name="payment[price]"]').value
      ).to eq(@payment1.price.to_s)
      expect(
        find('input[name="payment[registration_date]"]').value
      ).to eq(@payment1.registration_date.to_s)
      expect(
        find('select[name="payment[category_id]"]').value
      ).to eq(@payment1.category_id.to_s)
      expect(
        find('textarea[name="payment[memo]"]').value
      ).to eq(@payment1.memo.to_s)
      # 投稿内容を編集する
      fill_in 'payment-price', with: 10_000
      fill_in 'payment_registration_date', with: (Date.today - 1)
      select @sample.category.name.to_s, from: 'payment[category_id]'
      fill_in 'payment-memo', with: '備考欄です'
      # 編集を行なっても、Paymentテーブルのデータの件数は変わらない
      expect  do
        find('input[name="commit"]').click
      end.to change { Payment.count }.by(0)
      # 編集後はトップページに移動している
      expect(current_path).to eq root_path
      # 編集した内容がトップページに表示されている
      expect(page).to have_content('￥10000円')
      expect(page).to have_content((Date.today - 1).strftime('%Y-%m-%d').to_s)
      expect(page).to have_content("カテゴリー:#{@sample.category.name}")
    end
  end
  context '編集ができないとき' do
    it 'ログインしていないと編集ページへ移動できない' do
      # トップページへ移動する
      visit root_path
      # 未ログインでは編集へのリンクが存在しない
      expect(page).to have_no_content('編集')
      # 編集ページにアクセスすると、トップページへ移動する
      visit edit_payment_path(@payment1)
      expect(current_path).to eq root_path
    end
    it 'ログイン時でもペア登録ユーザーの投稿分は編集ができない' do
      # トップページに移動する
      visit root_path
      # ログインを行う
      sign_in(@payment1.user)
      # 編集アイコンをクリック
      all('.right-content-icon')[1].click
      # 編集という文字が表示されていない
      expect(page).to have_no_link '編集', href: edit_payment_path(@payment2)
      # 実際にペアユーザーの編集URLに移動すると、トップページに戻る
      visit edit_payment_path(@payment2)
      expect(current_path).to eq root_path
    end
    it 'ログイン時でも他ユーザーの投稿分は編集ができない' do
      # トップページへ移動する
      visit root_path
      # ログインをする
      sign_in(@payment1.user)
      # トップページに他ユーザーの投稿は表示されていない
      expect(page).to have_no_content(@payment3.price)
      # 他ユーザーの投稿編集ページにアクセスすると、トップページへ遷移する
      visit edit_payment_path(@payment3)
      expect(current_path).to eq root_path
    end
  end
end

RSpec.describe '支払い情報削除', type: :system do
  # メインのユーザー、メインのユーザーのペア登録をするユーザー、ペア登録されていないユーザーを用意
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
  end
  context '投稿の削除ができるとき' do
    it 'ログインしたユーザーは自分の投稿した内容を削除できる' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # アイコンをクリック
      all('.right-content-icon')[0].click
      # ログインユーザーが投稿した項目に編集ボタンがある
      expect(page).to have_link '削除', href: payment_path(@payment1)
      # 削除ボタンを押し、Paymentテーブルのデータが１つ減る
      expect do
        find_link('削除', href: payment_path(@payment1)).click
        page.accept_confirm
        expect(page).to have_no_content(@payment1.price)
      end.to change { Payment.count }.by(-1)
      # 削除後はトップページに移動している
      expect(current_path).to eq root_path
    end
  end
  context '編集ができないとき' do
    it 'ログインしていてもペアが入力した投稿を削除することはできない' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # ペアの投稿した編集アイコンをクリックする
      all('.right-content-icon')[1].click
      # 削除のリンクは存在しない
      expect(page).to have_no_link '削除', href: payment_path(@payment2)
    end
    it 'ログイン時でも他ユーザーの投稿分は編集ができない' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 他ユーザーの入力情報が表示されていない
      expect(page).to have_no_content(@payment3.price)
    end
  end
end

RSpec.describe '支払い情報詳細', type: :system do
  # メインのユーザー、メインのユーザーのペア登録をするユーザー、ペア登録されていないユーザーを用意
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
  end
  context '詳細ページが見ることができる' do
    it '自分の投稿した内容は詳細を見ることができる' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # 投稿した編集ボタンをクリックする
      all('.right-content-icon')[0].click
      # 詳細ページへのリンクが存在する
      expect(page).to have_link '詳細', href: payment_path(@payment1)
      # 詳細ページへ移動する
      visit payment_path(@payment1)
      # 詳細ページに日付、カテゴリー、金額、備考が表示されている
      expect(page).to have_content(@payment1.price)
      expect(page).to have_content(@payment1.registration_date)
      expect(page).to have_content(@payment1.category.name)
      expect(page).to have_content(@payment1.memo)
      # 詳細ページに編集ボタンと削除ボタンが存在する
      expect(page).to have_link '編集', href: edit_payment_path(@payment1)
      expect(page).to have_link '削除', href: payment_path(@payment1)
    end
    it 'ペア登録したユーザーが投稿した詳細ページを見ることができる' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # ペアユーザーが投稿した編集ボタンをクリックする
      all('.right-content-icon')[1].click
      # 詳細ページへのリンクが存在する
      expect(page).to have_link '詳細', href: payment_path(@payment2)
      # 詳細ページへ移動する
      visit payment_path(@payment2)
      # 詳細ページに日付、カテゴリー、金額、備考が表示されている
      expect(page).to have_content(@payment2.price)
      expect(page).to have_content(@payment2.registration_date)
      expect(page).to have_content(@payment2.category.name)
      expect(page).to have_content(@payment2.memo)
      # 詳細ページに編集ボタンと削除ボタンが存在しない
      expect(page).to have_no_link '編集', href: edit_payment_path(@payment2)
      expect(page).to have_no_link '削除', href: payment_path(@payment2)
    end
  end
  context '詳細ページを見ることができない' do
    it '他ユーザーの詳細ページを閲覧することはできない' do
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # トップページには他ユーザーの投稿が表示されていない
      expect(page).to have_no_content(@payment3.price)
      # 他ユーザーの詳細ページへアクセスすると、トップページへ遷移する
      visit payment_path(@payment3)
      expect(current_path).to eq root_path
    end
  end
end
