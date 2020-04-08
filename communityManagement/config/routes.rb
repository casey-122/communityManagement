Rails.application.routes.draw do

  #进入活动策划
  get 'activities/new'
  #创建活动策划
  post 'activities/create'
  #审批活动策划
  get 'activities/activity_active' => 'activities#activity_active'
  # 审核活动策划
  get 'activities/update_active/:activity_id' => 'activities#update_active'
  #下载活动策划案文件
  get '/activities/file_download/:id' => 'activities#file_download',as:"file_download"


  #进入审批社团页面
  get 'clubs/club_active' => 'clubs#club_active'
  #审批新建社团
  get 'clubs/update_active/:club_id' => 'clubs#update_active'

   # get 'news/new'
   #发布新闻
  post 'news/create'

  #进入新闻详情页
  get 'news/show_news/:new_id' => 'news#show_news'

  resources :news

  resources :activities
  resources :yong_hus
  resources :clubs
  devise_for :users
  root 'welcome#index'

  #社团详情，传递参数club_id(被查看社团的id)
  get 'clubs/show_clubs/:club_id' => 'clubs#show_clubs'

  #指定点击点赞按钮，调用的action以及定义要传递给action的参数
  get 'clubs/create_thumb/:club_id/:is_thumb' => 'clubs#create_thumb'

  #创建社团评论
  post 'clubs/create_comment' => 'clubs#create_comment'

  #删除社团评论
  get 'clubs/delete_comment/:comment_id' => 'clubs#delete_comment'

  #展开更多恢复(:comment_id为回复所属的评论的id，point为此次点击为第几次点击)
  get 'clubs/show_replys/:comment_id/:point' => 'clubs#show_replys'

  #更新个人信息
  post '/yong_hus/:id', to: 'yong_hus#update'
  get '/yong_hus/edit/:user_id', to: 'yong_hus#edit'
  post '/yong_hus/update', to: 'yong_hus#update'
  get '/yong_hus/show/:user_id', to: 'yong_hus#show'
  #管理员主界面
  get 'admin/admin'

  #社团简介主界面
  get 'welcome/clubIndex'

  #新闻通知主界面
  get '/welcome/newsIndex'
#  match '/announcement/club_introduction', to: 'announcement#club_introduction', via: 'get'

  #活动主界面
  get '/welcome/activityIndex'

  #创建社团
  get 'club/new'

  #保存社团信息
  post 'club/new(/:club)', to: 'club#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end