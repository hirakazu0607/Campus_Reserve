class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # SessionsHelperをincludeして全コントローラーで使用可能にする
  include SessionsHelper

  private

  # ログインしているか確認
  def require_login
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to new_session_path
    end
  end

  # スタッフ権限が必要
  def require_staff
    unless current_user&.staff?
      flash[:danger] = "この操作にはスタッフ権限が必要です"
      redirect_to root_path
    end
  end
end
