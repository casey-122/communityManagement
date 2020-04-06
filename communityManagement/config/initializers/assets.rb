# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# 指定需要预编译的文件类型
# 系统会将项目中所有以.js、.css、.png为后缀的文件进行预编译
# Rails.application.config.assets.precompile += %w(bootstrap/* *.css *.js */*.css */*.js *.png *.jpg *.jpeg *.gif */*.png */*.jpg */*.jpeg */*.gif)
 Rails.application.config.assets.precompile += %w( vendor/jquery.anystretch.min.js )