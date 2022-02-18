module SignInSupport
  def sign_in(user)
    # ログイン画面へ移動し、必要情報の入力、投稿ボタンの押下
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "パスワード", with: user.password
    find('input[name="commit"]').click
    # 遷移後のページがトップページになっているか
    expect(current_path).to eq(root_path)
    # トップページにログインユーザーの名前があるか
    expect(page).to have_content("#{user.nickname}")
  end
end