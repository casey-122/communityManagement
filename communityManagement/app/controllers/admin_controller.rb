class AdminController < ApplicationController
  before_action :authenticate_user!  # 這個是 devise 提供的方法，先檢查必須登入
  before_action :authenticate_admin # 再檢查是否有權限

  def index
  end

end
