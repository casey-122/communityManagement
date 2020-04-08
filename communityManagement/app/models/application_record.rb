class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def get_real_name
    real_name = YongHu.find_by(id:self.yong_hu_id).real_name
  end

  #得到申请用户邮箱
  def get_yong_hu_email
    user_id = YongHu.find_by(id:self.yong_hu_id).user_id
    email = User.find_by(user_id:user_id).email
    email
  end
end
