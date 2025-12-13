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
  // flashメッセージの閉じるボタン
  const closeButtons = document.querySelectorAll('[data-bs-dismiss="alert"]')
  closeButtons.forEach(button => {
    button.addEventListener('click', (e) => {
      const alert = e.target.closest('.alert')
      if (alert) {
        alert.style.transition = 'opacity 0.3s'
        alert.style.opacity = '0'
        setTimeout(() => {
          alert.remove()
        }, 300)
      }
    })
  })
  
  // 5秒後に自動で消す
  const alerts = document.querySelectorAll('.alert')
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.3s'
      alert.style.opacity = '0'
      setTimeout(() => {
        alert.remove()
      }, 300)
    }, 5000)
  })
})
