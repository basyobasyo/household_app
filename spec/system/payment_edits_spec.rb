require 'rails_helper'

def basic_pass(path)
  username = ENV["BASIC_AUTH_USER"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "支払い情報編集機能", type: :system do
    before do
      @payment1 = FactoryBot.build(:payment)
      @payment2 = FactoryBot.build(:payment)
      # トップページに表示させるため、本日の日付にする。
      @payment1.registration_date = Date.today
      @payment2.registration_date = Date.today
      # // トップページに表示させるため、本日の日付にする。
      @payment1.save
      @payment2.save
    end

    context '編集ができるとき' do
      it '全ての情報が正しく入力できている' do
        # ログインを行う
        basic_pass new_user_session_path
        visit new_user_session_path
        fill_in "Email", with: @payment1.user.email
        fill_in "パスワード", with: @payment1.user.password
        find('input[name="commit"]').click
        # ログイン後にトップページに移動していることの確認
        expect(current_path).to eq root_path
        # 
      end
    end
  end
