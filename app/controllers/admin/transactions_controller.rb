# frozen_string_literal: true

class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @pagy, @transactions = pagy(Transaction.all.order('transactions.created_at DESC'), items: 5)
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
