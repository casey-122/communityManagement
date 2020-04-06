class YongHu < ApplicationRecord

  def get_yong_hu_id
    yong_hu_id = YongHu.find_by(user_id:current_user.user.id).id
  end
end
