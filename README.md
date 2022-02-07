# アプリケーション名

Share Wallet

# アプリケーションの概要

2人で使うための家計簿アプリを作成した。日々の支払い情報を入力し、保存することが可能。また、立て替え分の精算を行うことができる。

# URL

https://household-app-36683.herokuapp.com/

# テスト用アカウント

Basic認証 ID : test  
Basic認証 PW : 1111  

テストアカウント  
メインユーザー email : main@gmail.com  
メインユーザー PW    : aaa111  
ペアユーザー　 email : pair@gmail.com  
ペアユーザー　 PW    : aaa111  

# 利用方法
1:ユーザーのログインを行う。アプリケーションの概要でも記述したが、2人で利用するアプリケーションであるため、ログイン後はペアとなるユーザーを選択する。1人で使用することも可能だが、後述する精算機能は2人で使うことを前提としているので、pairが登録されていない場合は使用できない。  
2:支払い情報の入力を行う。金額、日付、カテゴリーを入力する。備考は必須ではない。入力の編集、削除は、ログイン時のトップページにて編集ボタンより行う。  
3:精算ページにて精算を行う。精算する期間を入力し、精算ボタンを押下する。その後、精算結果出力ページに遷移し、結果が表示される。

# 目指した課題解決

結婚、同棲をしている方々の家計管理の課題を解決するためにこのアプリケーションを作成した。家計を共有しているが、どちらがどれだけ払ったのかという管理をするのは毎月発生する手間だと考えた。その問題を解決するために、アプリケーションを用いてどちらがどれだけ払っているのか、また、その立替分をどれだけ支払う必要があるのかを簡単に算出することができるようにした。

# 洗い出した要件

①ユーザー管理機能  
目的:ユーザーのログイン機能を実装するため。  
詳細:二人で使うことを前提としているため、ユーザーの登録、ログイン、ペアの設定を行うことができる。  
ストーリー:ユーザー登録したら相手の名前が表示されるようになる。また、ペアの入力した支払い情報も支払い情報一覧に表示され、ペア登録を用いて精算を行う。  
 
②支払い情報保存機能  
目的:日々の支払いの情報を保存するため  
詳細:日々の家計の支払いを入力し、DBに保存をすることができる。また、保存したものを一覧表示することができる。  
ストーリー:ユーザーは購入日、カテゴリー、金額、メモを入力することができ、詳細確認、編集、削除などを行うことができる。  
 
③精算機能  
目的:ある期間の精算を行うため。  
詳細:決められた期間の精算を行うことができる。  
ストーリー:Webページ上で期間の登録をすることができ、その間の精算情報を出力することができる。  


# 実装した機能についての画像やGIFおよびその説明
①ユーザー管理機能  
＊新規登録
![Image from Gyazo](https://i.gyazo.com/b0747d0fc110845f1927524efd169fce.gif)
・新規登録時はニックネーム、メールアドレス、パスワード、確認用パスワードを入力し、「sign up」を押下する。  
 
＊ログイン  
[![Image from Gyazo](https://i.gyazo.com/c3eafa25c071be7c9840a25934e9ed10.gif)](https://gyazo.com/c3eafa25c071be7c9840a25934e9ed10)
・ログイン時はメールアドレス、パスワードを入力し、「ログインする」を押下する。  

＊ペア登録
[![Image from Gyazo](https://i.gyazo.com/b0c8d740c6f3fef889fbfa1f95c125a7.gif)](https://gyazo.com/b0c8d740c6f3fef889fbfa1f95c125a7)
・家計を共有する相手を選択し、「登録する」を押下する。登録後は、画面右上「ペア登録」が表示され、相手の名前が表示される。
 
②支払い情報保存機能  

＊支払い情報の入力
[![Image from Gyazo](https://i.gyazo.com/0fb8059e1587370364b026097bbaa6ef.gif)](https://gyazo.com/0fb8059e1587370364b026097bbaa6ef)  
・新規入力は金額、日付、カテゴリー、備考欄を入力し、「入力を保存する」を押下する。入力の保存の際、備考欄は必須ではない。  
 
＊支払い情報の編集
[![Image from Gyazo](https://i.gyazo.com/f999bfaf39c5bda29a7ebd97054fb4e9.gif)](https://gyazo.com/f999bfaf39c5bda29a7ebd97054fb4e9)  
・編集は元のデータを入力された状態でフォーム画面へ遷移する。新規入力時と同様に金額、日付、カテゴリー、備考欄を入力し、「入力を保存する」を押下する。  
 
＊支払い情報の削除
[![Image from Gyazo](https://i.gyazo.com/5ffc2d290e675fa6ce5184a75a9c4ce3.gif)](https://gyazo.com/5ffc2d290e675fa6ce5184a75a9c4ce3)  
・削除は詳細ページより「削除」を押下する。  
 
③精算機能  
＊精算結果の出力  
[![Image from Gyazo](https://i.gyazo.com/5b79fb249e117ac75f3ff3be523e3d6e.gif)](https://gyazo.com/5b79fb249e117ac75f3ff3be523e3d6e)
・精算はトップページの「精算ページへ」を押下し、ページ遷移後、精算する期間をフォームに入力する。「精算を実行する」を押下すると、精算結果が出力される。  
 
# 実装予定の機能
・ペア登録許可機能  
ペア登録の申請が行うことができる機能。現状では、片方のユーザーが登録をした時点で登録が済んでしまい、意図しないユーザーとのペア登録となってしまうため。  
 
・ペア登録解除機能  
ペアの登録を解除できる機能。  
 
・精算結果の保存機能  
現状では指定された期間の精算結果を出力するのみとなっている。月々の精算結果を保存し、それらをグラフ化することで可視化ができるようにする。また、カテゴリー別に比較なども行えるようにし、どのカテゴリーの出費が増えたかなども確認ができるようにする機能。  
 
・JavaScriptを用いたフロント実装  
現状では、HTML、CSSを用いたフロント実装となっているため、JavaScriptを用いた実装を行う。  

# データベース設計

## users テーブル

| Column             | Type      | Options                  |
| ------------------ | --------- | ------------------------ |
| nickname           | string    | null: false              |
| email              | string    | null: false, unique :true|
| encrypted_password | string    | null: false              |
| pair_id            | reference | foreign_key :true        |

 - has_many :payments
 - has_one :another
 - belongs_to :pair

## payments テーブル

| Column            | Type      | Options                        |
| ----------------- | --------- | ------------------------------ |
| price             | integer   | null: false                    |
| registration_date | date      | null: false                    |
| category_id       | integer   | null: false                    |
| memo              | text      |                                |
| user              | reference | null: false, foreign_key: true |

 - belongs_to :user

 ## ER図

[![Image from Gyazo](https://i.gyazo.com/6d2f8bbe6cff0bfa84a74f1cd1da18fc.png)](https://gyazo.com/6d2f8bbe6cff0bfa84a74f1cd1da18fc)

 ## 画面遷移図

[![Image from Gyazo](https://i.gyazo.com/65ce25ac5676f33834cea55c7648b838.png)](https://gyazo.com/65ce25ac5676f33834cea55c7648b838)

# ローカルでの動作方法
以下のコマンドを入力してください

    $ git clone https://github.com/oji-123/household_app.git  
    $ cd household_app  
    $ bundle install  
    $ rails db:create  
    $ rails db:migrate  
    $ rails s  

その後、http://localhost:3000 へアクセスしてください。
