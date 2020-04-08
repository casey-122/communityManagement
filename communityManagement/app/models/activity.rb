class Activity < ApplicationRecord
  validates_presence_of :act_name, :message => "活动名不能为空！"
  validates_presence_of :start_time, :end_time, :message => "活动时间不能为空！"

  def get_club_name
    club_name = Club.find_by(id:self.club_id).club_name
    club_name
  end

  def get_yong_hu_name
    yong_hu_name = YongHu.find_by(id:self.yong_hu_id).real_name
    yong_hu_name
  end
end
