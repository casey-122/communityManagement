class NewsController < ApplicationController
  before_action :check_login, only: [:create]

  def index
    @news = New.all.order(club_id: :asc, created_at: :desc)
  end

  def file_download
    @news = Activity.find_by(id:params[:id])
    send_file "#{Rails.root}/public/upload/#{@news.file_url}"
  end

  def create
    puts("程序到这了：1")
    puts(session[:yong_hu_id])
    title = params[:new][:title]
    content = params[:new][:content].strip

    if title.blank?
      puts("程序到这了：2")

      flash.notice = "标题不能为空"
    elsif content.length < 5
      puts("程序到这了：3")

      flash.notice = "内容长度不能少于5个字"
    else
      @club = Club.find_by(yong_hu_id:session[:yong_hu_id])
      if @club
        club_id = @club.id
      else
        if current_user.chairman?  #设置社联主席发布的新闻的club_id为-1
          club_id = -1
        elsif current_user.admin?  #设置管理员发布的新闻的club_id为-2
          club_id = -2
        end
      end
      new = New.new(club_id:club_id, status:0)
      new.title = title
      new.content = content
      uploaded_file = params[:new][:file_url]
      File.open(Rails.root.join('public', 'upload', uploaded_file.original_filename), 'wb') do |file|
        file.write(uploaded_file.read)
      end
      new.file_url = uploaded_file.original_filename
      boolean = new.save
      puts("程序到这了：5")

      if boolean
        flash.notice = "发布成功"
        redirect_to news_index_path
      else
        flash.notice = "发布失败，请重新发布"
        render "/news/new"
      end
    end
  end

  #新闻详情
  def show_news
    new_id = params[:new_id]
    @new = New.find(new_id)
  end

end
