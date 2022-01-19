class PaymentsController < ApplicationController
  before_action :pair_check, only: :index
  before_action :set_params, only: [:show, :edit, :update, :destroy]
 
  def index
    if user_signed_in?
      if current_user.pair_id
        pair_user = User.find(current_user.pair_id)
        @payments = Payment.where(user_id: current_user.id).or(Payment.where(user_id: pair_user.id)).order("registration_date DESC")
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

  def show
  end

  def edit
  end

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
    @calculate_date_from = params[:date_from]
    @calculate_date_to   = params[:date_to]
    binding.pry
  end

  private

  def pair_check
    if user_signed_in?
       @pair_check = User.exists?(pair_id: current_user.id)
      if @pair_check
       @pair_user = User.find(current_user.pair_id)
      else
       @pair_user = false
      end
    end
  end

  def payment_params
    params.require(:payment).permit(:price, :registration_date, :category_id, :memo).merge(user_id: current_user.id)
  end

  def set_params
    @payment = Payment.find(params[:id])
  end

end

