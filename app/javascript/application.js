// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Bootstrap 5 （Popperも含む）
import "@popperjs/core"
import * as bootstrap from "bootstrap"

// Bootstrapをグローバルに設定
window.bootstrap = bootstrap

// ページ読み込み後の処理
document.addEventListener('turbo:load', () => {
  // flashメッセージを5秒後に自動で消す
  const alerts = document.querySelectorAll('.alert')
  alerts.forEach(alert => {
    setTimeout(() => {
      // Bootstrap の Alert インスタンスを取得して閉じる
      const bsAlert = bootstrap.Alert.getOrCreateInstance(alert)
      bsAlert.close()
    }, 5000)
  })
})
