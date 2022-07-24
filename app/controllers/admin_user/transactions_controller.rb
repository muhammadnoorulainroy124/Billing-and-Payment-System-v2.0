# frozen_string_literal: true

module AdminUser
  class TransactionsController < ApplicationController
    layout 'admin'
    before_action :set_transaction, only: %i[destroy]

    def index
      @pagy, @transactions = pagy(Transaction.all.order('transactions.created_at DESC'), items: 5)
      authorize @transactions
    end

    def destroy
      @transaction.destroy
      flash[:success] = 'Transaction deleted successfully'
      redirect_to admin_transactions_path
    end

    private

    def set_transaction
      @transaction = Transaction.find(params[:id])
      authorize @transaction
    end
  end
end
