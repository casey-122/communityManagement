class ActivitiesController < ApplicationController
  before_action :check_login

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
      redirect_to root_path
      # redirect_to activity_path(@activity.id)
      # redirect_to "/activities/show/#{@activity.id}"
    else
      redirect_to activities_new_path
    end
  end

  def activity_active
    @activities = Activity.where(status:0)
  end

  def update_active
    activity_id = params[:activity_id]
    activity = Activity.find(activity_id)
    activity.status = 1
    activity.save
    redirect_to activities_activity_active_path
  end

  private
  def activity_params
    params.require(:activity).permit(:act_name, :act_describe, :start_time, :end_time, :act_address, :plan_url)
  end
end
