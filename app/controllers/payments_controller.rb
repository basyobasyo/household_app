class PaymentsController < ApplicationController
  before_action :pair_check, only: :index
  before_action :set_params, only: %i[show edit update destroy]

  def index
    if user_signed_in?
      if current_user.pair_id
        pair_user = User.find(current_user.pair_id)
        @payments = Payment.where(user_id: current_user.id).or(Payment.where(user_id: pair_user.id)).order('registration_date DESC')
      else
        @payments = Payment.where(user_id: current_user.id)
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

  def show; end

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

  def calculate_page
    # if user_signed_in?
    #   if current_user.pair_id
    #     pair_user = User.find(current_user.pair_id)
    #     @payments = Payment.where(user_id: current_user.id).or(Payment.where(user_id: pair_user.id)).order("registration_date DESC")
    #     #DBとのやりとりはモデルに書いたほうがいいのでは
    #   else
    #     redirect_to root_path
    #     # ここにアラートを実装しておく
    #   end
    # end
    # @calculate_date_from = params[:date_from]
    # @calculate_date_to   = params[:date_to]
    # 受け取りのための変数を作成。ページ上に入力フォームを作成し、それを用いて精算を行えるようにする。
  end

  def calculate_result
    date_from = date_complete(params['date_from(1i)'], params['date_from(2i)'], params['date_from(3i)'])
    date_to   = date_complete(params['date_to(1i)'], params['date_to(2i)'], params['date_to(3i)'])
    main_result = Payment.calculate(date_from, date_to, current_user.id)
    pair_result = Payment.calculate(date_from, date_to, current_user.pair_id)
    if main_result > pair_result
      @pay_user     = User.find(current_user.pair_id)
      @receive_user = User.find(current_user.id)
    elsif main_result < pair_result
      @pay_user     = User.find(current_user.id)
      @receive_user = User.find(current_user.pair_id)
    end
    @result = (main_result - pair_result).abs / 2
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
  end

  def date_complete(year, month, day)
    format('%04d', year) + format('%02d', month) + format('%02d', day)
  end
end
