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
    if current_user.blank?
      flash.notice = "您还没有登录，请先登录"
      redirect_to new_session_path(:user)
    else
      if yong_hu_id = YongHu.find_by(user_id:current_user.user_id).id
        session[:yong_hu_id] = yong_hu_id
        current_user ||= session[:yong_hu_id] && YongHu.find(session[:yong_hu_id])
      else
        flash.notice = "您还没有完善个人信息"
        redirect_to yong_hu_path(id:current_user.user_id)
      end
    end
  end



  protected

  def configure_permitted_parameters
    added_attrs = [:user_id, :role, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
