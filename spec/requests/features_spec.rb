# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Features', type: :request do
  describe 'GET /' do
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:buyer) { FactoryBot.create(:buyer) }
    let!(:feature) { FactoryBot.create(:feature) }
    let!(:params) { { feature: { name: 'csdfsfd', code: 'fea333', unit_price: 3000, max_unit_limit: 20 } } }

    describe 'index' do
      context 'when index action called with admin sign in' do
        before do
          sign_in admin
          get admin_features_path
        end

        it 'must return all features' do
          expect(assigns[:features].count).to eq(Feature.all.count)
          expect(response).to have_http_status(:ok)
          assert(response.content_type, 'text/html')
        end
      end

      context 'when index action called without admin signed in' do
        before do
          get admin_features_path
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
          get admin_features_path
        end

        it 'must redirect to buyer_root_path' do
          expect(response).to have_http_status(:found)
          expect(response.content_type).to eq('text/html')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'show' do
      context 'when show action called with admin signed in' do
        before do
          sign_in admin
          get admin_feature_url(feature.id), xhr: true
        end

        it 'must show feature details' do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('text/javascript')
          expect(assigns[:feature].name).to eq(feature.name)
          expect(assigns[:feature].unit_price).to eq(feature.unit_price)
          expect(assigns[:feature].max_unit_limit).to eq(feature.max_unit_limit)
          expect(assigns[:feature].code).to eq(feature.code)
        end
      end

      context 'when show action with invalid id' do
        before do
          sign_in admin
          get admin_feature_url(3000), xhr: true
        end

        it 'must show error record not found' do
          expect(flash[:error]).to eq('Record not found.')
        end
      end

      context 'when show action called without admin signed in' do
        before do
          get admin_feature_url(feature.id), xhr: true
        end

        it 'must respond unauthorized' do
          expect(response).to have_http_status(:unauthorized)
          expect(response.content_type).to eq('text/javascript')
          expect(response.body).to include('You need to sign in or sign up before continuing.')
        end
      end
    end

    describe 'new action' do
      context "when new action is called with admin signed in" do
        before do
          sign_in admin
          get new_admin_feature_path
        end
        it 'must create Feature instance' do
          expect(assigns[:feature]).to be_instance_of(Feature)
        end
      end

      context "when new action is called without admin signed in" do
        before do
          get new_admin_feature_path
        end
        it 'must redirect' do
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "when new action is called with buyer signed in" do
        before do
          sign_in buyer
          get new_admin_feature_path
        end
        it 'must redirect to buyer root' do
          expect(response).to redirect_to(root_path)
        end
      end


    end

    describe 'create action' do
      before do
        sign_in admin
        post admin_features_path, params: params
      end

      context 'when create action called with admin singed in and valid attributes' do
        it 'must create feature' do
          expect(assigns[:feature]).to be_instance_of(Feature)
          expect(response.content_type).to eq('text/html')
          expect(assigns[:feature].name).to eq(params[:feature][:name])
          expect(assigns[:feature].code).to eq(params[:feature][:code])
          expect(assigns[:feature].unit_price).to eq(params[:feature][:unit_price])
          expect(assigns[:feature].max_unit_limit).to eq(params[:feature][:max_unit_limit])
          expect(flash[:success]).to eq('Feature was successfully created.')
        end
      end

      context 'when create action called with admin singed in and invalid attributes' do
        let!(:params) { { feature: { name: 'abc@', code: 'abceweee', unit_price: '#$%bcd', max_unit_limit: '@534' } } }

        it 'must not create feature' do
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'create action without admin sign in' do
      before do
        post admin_features_path, params: params
      end

      context 'when create action called without admin sign in' do
        it 'must respond unauthorized' do
          expect(response).to have_http_status(:found)
          assert(response.content_type, 'text/html')
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe 'create action without admin sign in' do
      before do
        post admin_features_path, params: params
        sign_in buyer
      end

      context 'when create action called with buyer signed in' do
        it 'must redirect' do
          expect(response.content_type).to eq('text/html')
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe 'update action' do
      context 'with admin signed in and valid attributes' do
        before do
          sign_in admin
          patch admin_feature_url(feature.id),
                params: { feature: { name: 'csdfsfd', code: 'fea333', max_unit_limit: 40 } }
        end

        it 'is expected to update the feature' do
          expect(assigns[:feature].name).to eq('csdfsfd')
          expect(assigns[:feature].code).to eq('fea333')
          expect(assigns[:feature].max_unit_limit).to eq(40)
          expect(assigns[:feature]).to be_instance_of(Feature)
          expect(response.content_type).to eq('text/html')
          expect(flash[:success]).to eq('Feature was successfully updated.')
        end
      end

      context 'with invalid attributes' do
        before do
          sign_in admin
          patch admin_feature_url(feature.id),
                params: { feature: { name: 'csdfsfd', code: 'fea333', max_unit_limit: '#43@' } }
        end

        it 'must not update feature and render edit' do
          expect(assigns[:feature].name).to eq('csdfsfd')
          expect(assigns[:feature].code).to eq('fea333')
          expect(assigns[:feature].max_unit_limit).to eq(0)
          expect(assigns[:feature]).to be_instance_of(Feature)
          expect(response.content_type).to eq('text/html')
          expect(response).to render_template(:edit)
        end
      end

      context 'without admin signed in' do
        before do
          patch admin_feature_url(feature.id),
                params: { feature: { name: 'csdfsfd', code: 'fea333', max_unit_limit: '#43@' } }
        end

        it 'must redirect' do
          assert(response.content_type, 'text/html')
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'with buyer signed in' do
        before do
          sign_in buyer
          patch admin_feature_url(feature.id),
                params: { feature: { name: 'csdfsfd', code: 'fea333', max_unit_limit: '#43@' } }
        end

        it 'must redirect to buyer' do
          assert(response.content_type, 'text/html')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'delete action' do
      before do
        sign_in admin
      end

      context 'when destroy action called with admin signed in' do
        it 'must destroy feature' do
          delete admin_feature_url(feature.id)
          expect { Feature.find(feature.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when destroy action is called with invalid feature id' do
        it 'must not delete feature' do
          delete admin_feature_url(4354)
          expect(Feature.find(feature.id).name).to eq(feature.name)
        end
      end
    end
  end
end
