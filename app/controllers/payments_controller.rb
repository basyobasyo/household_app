class PaymentsController < ApplicationController
  before_action :pair_check, only: :index
  before_action :set_params, only: %i[edit update destroy]
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in?
      if current_user.pair_id
        pair_user = User.find(current_user.pair_id)
        all_payments = Payment.where(user_id: [current_user.id,
                                               pair_user.id]).where(registration_date: (30.days.ago)..(Time.now))
        @payments = all_payments.page(params[:page]).per(10).order('registration_date DESC')
        main_payments = all_payments.where(user_id: current_user.id)
        pair_payments = all_payments.where(user_id: pair_user.id)
        @main_result = result(main_payments)
        @pair_result = result(pair_payments)
      else
        @payments = Payment.where(user_id: current_user.id).where(registration_date: (30.days.ago)..(Time.now)).page(params[:page]).per(10).order('registration_date DESC')
      end
    end
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @payment = Payment.find(params[:id])
    redirect_to root_path unless @payment.user == current_user || @payment.user == current_user.pair
  end

  def edit; end

  def update
    if @payment.update(payment_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @payment.destroy
    redirect_to root_path
  end

  def follow
    @follow_id  = params[:follow_id]
    @another_id = params[:another_id]
    User.follow(@follow_id, @another_id)
    redirect_to root_path
  end

  def unfollow
    user_id = params[:id]
    User.pair_unfollow(user_id)
    redirect_to root_path
  end

  def calculate_page; end

  def calculate_result
    date_from = params[:date_from]
    date_to   = params[:date_to]
    if date_from == '' || date_to == ''
      flash.now[:calculate_error] = '精算を行うことができませんでした。値が空では精算ができません。'
      render action: 'calculate_page'
    elsif (Date.parse(date_to) - Date.parse(date_from)).to_i >= 0
      main_result = Payment.calculate(date_from, date_to, current_user.id)
      pair_result = Payment.calculate(date_from, date_to, current_user.pair_id)
      if main_result > pair_result
        @pay_user     = User.find(current_user.pair_id)
        @receive_user = User.find(current_user.id)
      elsif main_result < pair_result
        @pay_user     = User.find(current_user.id)
        @receive_user = User.find(current_user.pair_id)
      elsif main_result == 0 && pair_result == 0
        flash.now[:calculate_error] = '指定された期間に支払い情報がありませんでした。'
        render action: 'calculate_page'
      end
      @result = (main_result - pair_result).abs / 2
    elsif (Date.parse(date_to) - Date.parse(date_from)).to_i < 0
      flash.now[:calculate_error] = '精算を行うことができませんでした。正しく値を入力して下さい。'
      render action: 'calculate_page'
    end
  end

  private

  def pair_check
    if user_signed_in?
      @pair_check = User.exists?(pair_id: current_user.id)
      @pair_user = if @pair_check
                     User.find(current_user.pair_id)
                   else
                     false
                   end
    end
  end

  def payment_params
    params.require(:payment).permit(:price, :registration_date, :category_id, :memo).merge(user_id: current_user.id)
  end

  def set_params
    @payment = Payment.find(params[:id])
    redirect_to root_path if @payment.user != current_user
  end

  def result(data)
    result = 0
    data.each do |payment|
      result += payment[:price]
    end
    result
  end
end
