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
    end
  end
end