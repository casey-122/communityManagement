class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_admin
    unless current_user.admin?
      # flash[:alert] = "Not allow!"
      redirect_to('admin/index')
    end
  end

  # 检查当前是否有用户登录
  def check_login
    yong_hu_id = YongHu.find_by(user_id:current_user.user_id).id
    session[:yong_hu_id] = yong_hu_id
    current_user ||= session[:yong_hu_id] && YongHu.find(session[:yong_hu_id])
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:user_id, :role, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
