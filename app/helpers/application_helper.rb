module ApplicationHelper
  # Railsのフラッシュタイプ（:notice, :alert, :error, :success）を
  # Bootstrapのアラートクラスにマッピング
  def bootstrap_alert_class(flash_type)
    case flash_type.to_sym
    when :success
      'success'
    when :notice
      'info'
    when :alert
      'warning'
    when :error, :danger
      'danger'
    else
      'secondary'
    end
  end
end
