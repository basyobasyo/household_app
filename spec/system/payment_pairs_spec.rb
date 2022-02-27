require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ペア登録機能', type: :system do
  before do
    @payment1 = FactoryBot.create(:payment) # メインユーザー
    @payment2 = FactoryBot.create(:payment) # ペアユーザー
    @payment3 = FactoryBot.create(:payment) # 他ユーザー
  end
  context 'ペア登録ができるとき' do
    it 'ペア未登録時で対象ユーザーが存在しているときは登録ができる' do
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # ペア登録欄に@payment2の名前を選択する
      select @payment2.user.nickname, from: 'follow_id'
      # 「登録する」をクリックする
      find('input[name="commit"]').click
      # トップページに戻り、ペアの名前が表示されている
      expect(current_path).to eq root_path
      expect(page).to have_content @payment2.user.nickname
    end
  end
  context 'ペア登録できないとき' do
    it '既にペア登録されている場合、ペア登録できない' do
      # ペア登録をされている状態にする
      @user1 = @payment1.user
      @user1.update(pair_id: @payment2.user.id)
      @user2 = @payment2.user
      @user2.update(pair_id: @payment1.user.id)
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # トップページにペア登録機能の表示がない
      expect(page).to have_no_content '共有先を登録しましょう'
    end
  end
end

RSpec.describe 'ペア登録解除', type: :system do
  before do
    @payment1 = FactoryBot.create(:payment) # メインユーザー
    @payment2 = FactoryBot.create(:payment) # ペアユーザー
    @payment3 = FactoryBot.create(:payment) # 他ユーザー
  end
  context 'ペア登録解除できるとき' do
    it '既にペア登録している場合' ,js: true do 
      # ペア登録をされている状態にする
      @user1 = @payment1.user
      @user1.update(pair_id: @payment2.user.id)
      @user2 = @payment2.user
      @user2.update(pair_id: @payment1.user.id)
      # Basic認証のログインを行う
      basic_pass new_user_session_path
      # トップページへ移動する
      visit root_path
      # ログインする
      sign_in(@payment1.user)
      # ペア登録しているユーザーの名前がトップページに存在する
      expect(page).to have_content @payment2.user.nickname
      # ペア登録しているユーザーのニックネームをクリックする
      # find_by_id('pair-nickname').click
      # all('.pair-name-position')[0].click
      # binding.pry
      # 「ペアの解除」が表示されている
      # expect(page).to have_link "ペアの解除", href: unfollow_payment_path(@payment1.id)
      # ペア登録の解除を行う
      # visit unfollow_payment_path(@payment1.id)
    end
  end
end