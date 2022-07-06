# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource.type
    when 'Admin'
      admin_root_path
    when 'Buyer'
      buyer_root_path
    end
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :type) }
    devise_parameter_sanitizer.permit(:accept_invitation,
                                      keys: %i[name password password_confirmation type])
  end

  private

  def record_not_found
    flash[:alert] = 'Record not found.'
    redirect_to request.referer || root_path
  end
end
