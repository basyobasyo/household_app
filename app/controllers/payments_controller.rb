class PaymentsController < ApplicationController
  before_action :pair_check, only: :index

  def index
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    binding.pry
      if @payment.save
        redirect_to root_path
      else
        render :new
      end
  end

  def follow
    @follow_id  = params[:follow_id]
    @another_id = params[:another_id]
    User.follow(@follow_id, @another_id)
    redirect_to root_path
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

end

