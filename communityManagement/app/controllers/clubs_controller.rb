class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:index, :show_clubs]

  # 通过这个方法的认证后才能访问所请求的动作，这里除了 index 和 show 动作，其他动作都要通过身份验证才能访问
  # http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.where(status:1)
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
  end

  #进入社团详情页/评论页面
  def show_clubs
    club_id = params[:club_id]
    @club = Club.find(club_id)
    #as_type为0时代表社团的评论，为1时代表评论的回复
    @club_comments = ClubComment.where(club_id:club_id, as_type:0).order(updated_at: :desc).page(params[:page]).per(10)
    puts(@club_comments.count)
  end

  #点赞
  def create_thumb
    club_id = params[:club_id]
    is_thumb = params[:is_thumb]
    yong_hu_id = YongHu.find_by(user_id:current_user.user_id).id
    thumb = Thumb.find_or_create_by(yong_hu_id:yong_hu_id, club_id:club_id)
    if is_thumb == "0"
      thumb.is_thumb = false
    elsif is_thumb == "1"
      thumb.is_thumb = true
    end
    thumb.save
  end

  #创建评论
  def create_comment
    puts("程序走到这了：1")
    #将客户端提交的参数保存到变量中
    as_type = params[:as_type].to_i
    content = params[:comment]
    club_id = params[:club_id]

    puts("程序走到这了：2")
    # puts("as_type:"+ as_type)
    puts("content:"+ content)
    puts("club_id:"+ club_id)

    #先判断当前是否有用户登录，没有登录需要提示登录
    if current_user.blank?
      flash.notice = "您还未登录，请先登录！"
      redirect_to "/clubs/show_clubs/#{club_id}"
    #再判断评论内容是否为空，内容为空，提示并且返回到社团详情页面
    elsif content.blank?
      flash.notice = "评论内容不能为空！"
      redirect_to "/clubs/show_clubs/#{club_id}"
    else
      puts("程序走到这了：3")

      #as_type参数为0时，说明是社团的评论
      if as_type == 0
        #创建评论
        puts("程序走到这了：5")

        boolean_0 = ClubComment.create(status:0, yong_hu_id:session[:yong_hu_id], as_type:as_type, content:content, club_id:club_id)
        if boolean_0
          flash.notice = "评论成功"
        else
          flash.notice = "评论失败，请重新评论"
        end
        #重定向到帖子详情页面
        redirect_to "/clubs/show_clubs/#{club_id}"
      #as_type参数为1时，说明是评论下面的回复
      elsif as_type == 1
        puts("程序走到这了：4")

        comment_id = params[:comment_id]
        re_reply_id = params[:re_reply_id]
        boolean_1 = ClubComment.create(status:0, yong_hu_id:session[:yong_hu_id], as_type:as_type, content:content, club_id:club_id, re_comment_id:comment_id, re_reply_id:re_reply_id)
        if boolean_1
          flash.notice = "回复成功"
        else
          flash.notice = "回复失败，请重新回复"
        end
        redirect_to "/clubs/show_clubs/#{club_id}"
      end
    end
  end

  #删除评论
  def delete_comment
    comment_id = params[:comment_id]
    comment = ClubComment.find(comment_id)
    club_id = comment.club_id
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
    @reply_part = ClubComment.where(re_comment_id:@comment_id, as_type:1)
  end

  # GET /clubs/new
  def new
    puts(session[:yong_hu_id])
    club0 = Club.find_by(yong_hu_id:session[:yong_hu_id])
    if club0
      flash.notice = "您已经是位社长大人了，不可以再创建其他社团哟"
      redirect_to root_path
    else
      @club = Club.new
    end
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @yong_hu = YongHu.find_by(user_id: current_user.user_id)
    @club = Club.new(club_params)
    @club.yong_hu_id = @yong_hu.id
    @club.status = '0'

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: '提交申请成功，等待社联大大审批中……' }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  #进入审批新社团页面
  def club_active
    @clubs = Club.where(status:0)
  end

  #审批新建社团
  def update_active
    club_id = params[:club_id]
    club = Club.find(club_id)
    club.status = 1
    club.save
    redirect_to clubs_club_active_path
  end

  # PATCH/PUT /clubs/1
  # PATCH/PUT /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club.destroy
    respond_to do |format|
      format.html { redirect_to clubs_url, notice: 'Club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def club_params
      # @user_id = current_user.id
      params.require(:club).permit(:club_name, :club_email, :club_brief, :found_time)
    end
end
