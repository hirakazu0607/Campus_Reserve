// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Bootstrap 5の初期化（CDN経由で読み込む方式に変更）
// importmapの問題を回避するため、HTMLで直接読み込みます

// ページ読み込み時とTurbo遷移時の両方で実行
function initializePage() {
  // Bootstrapがグローバルに読み込まれるまで待つ
  if (typeof window.bootstrap !== 'undefined') {
    // flashメッセージを5秒後に自動で消す
    const alerts = document.querySelectorAll('.alert')
    alerts.forEach(alert => {
      setTimeout(() => {
        const bsAlert = window.bootstrap.Alert.getOrCreateInstance(alert)
        bsAlert.close()
      }, 5000)
    })
  }
}

// Turbo使用時
document.addEventListener('turbo:load', initializePage)

// 通常のページロード時（念のため）
document.addEventListener('DOMContentLoaded', initializePage)
