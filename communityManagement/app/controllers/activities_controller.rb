class ActivitiesController < ApplicationController
  before_action :check_login, except:[:index, :show_activities, :file_download]

  def index
    @activities = Activity.where(status:1)
  end

  def new

  end

  def show
    @activity = Activity.find_by(id:params[:id])
  end

  def file_download
    @activity = Activity.find_by(id:params[:id])
    send_file "#{Rails.root}/public/upload/#{@activity.plan_url}"
  end

  def create
    @yong_hu = YongHu.find_by(id:session[:yong_hu_id])
    puts("程序到这儿了：1")
    puts(session[:yong_hu_id])
    @club = Club.find_by(yong_hu_id:session[:yong_hu_id])
    puts("程序到这儿了：2")
    puts(@club.id)
    @activity = Activity.new(activity_params)
    puts(@activity.act_name)
    @activity.club_id = @club.id
    @activity.yong_hu_id = @yong_hu.id
    uploaded_file = params[:activity][:plan_url]
    File.open(Rails.root.join('public', 'upload', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    @activity.plan_url = uploaded_file.original_filename
    @activity.status = 0
    if @activity.save
      flash.notice = "活动策划提交成功，请耐心等待审核……"
      # redirect_to root_path
       redirect_to activity_path(@activity.id)
      # redirect_to "/activities/show/#{@activity.id}"
    else
      redirect_to activities_new_path
    end
  end

  #展示需要审批的活动页面
  def activity_active
    @activities = Activity.where(status:0)
  end

  #审批活动
  def update_active
    activity_id = params[:activity_id]
    activity = Activity.find(activity_id)
    activity.status = 1
    activity.save
    redirect_to activities_activity_active_path
  end

  #点赞
  def create_thumb
    act_id = params[:act_id]
    is_thumb = params[:is_thumb]
    yong_hu_id = YongHu.find_by(user_id:current_user.user_id).id
    thumb = ActThumb.find_or_create_by(yong_hu_id:yong_hu_id, act_id:act_id)
    if is_thumb == "0"
      thumb.is_thumb = false
    elsif is_thumb == "1"
      thumb.is_thumb = true
    end
    thumb.save
  end

  #进入活动详情页/评论页面
  def show_activities
    act_id = params[:act_id]
    @activity = Activity.find(act_id)
    #as_type为0时代表社团的评论，为1时代表评论的回复
    @act_comments = ActComment.where(act_id:act_id, as_type:0)
                         .order(updated_at: :desc).page(params[:page]).per(10)
    puts(@act_comments.count)
  end

  #创建评论
  def create_comment
    puts("程序走到这了：1")
    #将客户端提交的参数保存到变量中
    as_type = params[:as_type].to_i
    content = params[:comment]
    act_id = params[:act_id]

    puts("程序走到这了：2")
    puts("content:"+ content)
    puts("club_id:"+ act_id)

    #先判断当前是否有用户登录，没有登录需要提示登录
    if current_user.blank?
      flash.notice = "您还未登录，请先登录！"
      redirect_to "/activities/show_activities/#{act_id}"
      #再判断评论内容是否为空，内容为空，提示并且返回到社团详情页面
    elsif content.blank?
      flash.notice = "评论内容不能为空！"
      redirect_to "/activities/show_activities/#{act_id}"
    else
      puts("程序走到这了：3")

      #as_type参数为0时，说明是社团的评论
      if as_type == 0
        #创建评论
        puts("程序走到这了：5")

        boolean_0 = ActComment.create(status:0, yong_hu_id:session[:yong_hu_id], as_type:as_type, content:content, act_id:act_id)
        if boolean_0
          flash.notice = "评论成功"
        else
          flash.notice = "评论失败，请重新评论"
        end
        #重定向到帖子详情页面
        redirect_to "/activities/show_activities/#{act_id}"
        #as_type参数为1时，说明是评论下面的回复
      elsif as_type == 1
        puts("程序走到这了：4")

        comment_id = params[:comment_id]
        re_reply_id = params[:re_reply_id]
        boolean_1 = ActComment.create(status:0, yong_hu_id:session[:yong_hu_id], as_type:as_type, content:content, act_id:act_id, re_comment_id:comment_id, re_reply_id:re_reply_id)
        if boolean_1
          flash.notice = "回复成功"
        else
          flash.notice = "回复失败，请重新回复"
        end
        redirect_to "/activities/show_activities/#{act_id}"
      end
    end
  end

  #删除评论
  def delete_comment
    comment_id = params[:comment_id]
    comment = ActComment.find(comment_id)
    act_id = comment.act_id
    #clubcomments表中status为1代表自己删除，为2代表管理员删除
    if session[:yong_hu_id] == comment.yong_hu_id
      comment.status = 1
    else current_user.admin? || current_user.chairman?
      comment.status = 2
    end
    comment.save
  end

  #展开更多回复
  def show_replys
    @comment_id = params[:comment_id]
    @point = params[:point].to_i
    #定义每次加载的条数
    @step = 8
    #找到comment_id代表的评论下面所有的回复
    @reply_part = ActComment.where(re_comment_id:@comment_id, as_type:1)
  end



  private
  def activity_params
    params.require(:activity).permit(:act_name, :act_describe, :start_time, :end_time, :act_address, :plan_url)
  end
end
