class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
   @pagy, @transactions = pagy(Transaction.all, items: 10)
    authorize @transactions
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    authorize @transaction
    @transaction.destroy
    flash[:success] = 'Transaction deleted successfully'
    redirect_to admin_transactions_path
  end
end
