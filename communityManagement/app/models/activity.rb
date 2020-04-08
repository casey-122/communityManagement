class Activity < ApplicationRecord
  validates_presence_of :act_name, :message => "活动名不能为空！"
  validates_presence_of :start_time, :end_time, :message => "活动时间不能为空！"

  #获得活动社团名
  def get_club_name
    club_name = Club.find_by(id:self.club_id).club_name
    club_name
  end

  #获得活动社团社长名
  def get_yong_hu_name
    yong_hu_name = YongHu.find_by(id:self.yong_hu_id).real_name
    yong_hu_name
  end


  #获取评论数，目前还未建立评论表，默认评论数为1
  def get_activity_items
    num = ActComment.where(act_id:self.id).count
  end

  #获取点赞数，目前还未建立点赞表，默认点赞数为1
  def get_thumbs
    num = ActThumb.where(act_id:self.id).count
  end

  #获取此用户是否给该活动点过赞，默认为未点过
  def get_thumb_info(yong_hu_id)
    thumb = ActThumb.find_by(act_id:self.id, yong_hu_id:yong_hu_id)
    boolean = false
    if thumb && thumb.is_thumb
      boolean = true
    end
  end
end
