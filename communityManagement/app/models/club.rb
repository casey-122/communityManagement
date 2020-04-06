class Club < ApplicationRecord
  has_many :club_comments, dependent: :destroy
  has_many :news
  #dependert 选项可以使得删除一个社团时，社团的相关留言也删除
  #这两行声明能够启用一些自动行为。
  # 例如，如果 @club 实例变量表示一篇文章，
  # 就可以使用 @club.comments 以数组形式取回这个社团的所有留言。
  validates :club_name, presence: true

  #获取社长真实姓名
  def get_real_name
    yong_hu_id = self.yong_hu_id
    yong_hu = YongHu.find_by(id:yong_hu_id)
    real_name = "此用户未命名"
    if yong_hu
      real_name = yong_hu.real_name
    end
  end

  #获取评论数
  def get_club_items
    num = ClubComment.where(club_id:self.id).count
  end

  #获取点赞数
  def get_thumbs
    num = Thumb.where(club_id:self.id, is_thumb:true).count
  end

  #获取此用户是否给该社团点过赞，默认为未点过
  def get_thumb_info(yong_hu_id)
    thumb = Thumb.find_by(club_id:self.id, yong_hu_id:yong_hu_id)
    boolean = false
    if thumb && thumb.is_thumb
      boolean = true
    end
  end
end
