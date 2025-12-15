class User < ApplicationRecord
  # 🔐 パスワードを暗号化（bcrypt使用）
  has_secure_password

  # 0 = student（学生）、1 = staff（教職員）
  enum :role, { student: 0, staff: 1 }, default: :student

  # ✅ バリデーション（入力チェック）

  # 氏名は必須
  validates :name, presence: true, length: { maximum: 50 }

  # 学籍番号・社員番号は必須、一意
  validates :student_or_staff_number, presence: true,
                                      uniqueness: true,
                                      numericality: { only_integer: true, greater_than: 0 }

  # メールアドレスは必須、一意、正しい形式
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  # パスワードは6文字以上（作成時は必須、更新時は変更する場合のみ）
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, allow_nil: true

  # ロールは必須
  validates :role, presence: true

  # アソシエーション
  has_many :reservations, dependent: :destroy

  # メールアドレスを小文字で保存
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
