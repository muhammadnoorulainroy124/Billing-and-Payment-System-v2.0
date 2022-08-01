# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  describe 'GET /' do
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:buyer) { FactoryBot.create(:buyer) }
    let!(:transaction) { FactoryBot.create(:transaction) }

    describe 'index' do
      context 'when index action called with admin sign in' do
        before do
          sign_in admin
          get admin_transactions_path
        end

        it 'must return all features' do
          expect(assigns[:transactions].count).to eq(Transaction.all.count)
          expect(response).to have_http_status(:ok)
          assert(response.content_type, 'text/html')
        end
      end

      context 'when index action called without admin signed in' do
        before do
          get admin_transactions_path
        end

        it 'must redirect to signin page' do
          expect(response).to have_http_status(:found)
          assert(response.content_type, 'text/html')
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'when index action called with buyer signed in' do
        before do
          sign_in buyer
          get admin_transactions_path
        end

        it 'must redirect to buyer_root_path' do
          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq('text/html')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'delete action' do
      before do
        sign_in admin
      end

      context 'when destroy action called with admin signed in' do
        it 'must destroy transaction' do
          delete admin_transaction_url(transaction.id)
          expect { Transaction.find(transaction.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when destroy action is called with invalid transaction id' do
        it 'must not delete transaction' do
          delete admin_transaction_url(4354)
          expect(Transaction.find(transaction.id).buyer_name).to eq(transaction.buyer_name)
        end
      end
    end

    describe 'delete action with buyer signed in' do
      before do
        sign_in buyer
      end

      context 'when destroy action called with buyer signed in' do
        it 'must not destroy transaction and redirect' do
          delete admin_transaction_url(transaction.id)
          expect(Transaction.find(transaction.id).buyer_name).to eq(transaction.buyer_name)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
