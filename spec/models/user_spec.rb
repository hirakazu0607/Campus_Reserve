require 'rails_helper'

RSpec.describe User, type: :model do
  # 🏭 FactoryBotでテスト用ユーザーを作成
  describe 'FactoryBot' do
    it '有効なユーザーを作成できる' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '教職員ユーザーを作成できる' do
      staff = build(:user, :staff)
      expect(staff.staff?).to be true
    end
  end

  # ✅ バリデーションのテスト
  describe 'validations' do
    it '氏名が必須であること' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it '学籍番号・社員番号が必須であること' do
      user = build(:user, student_or_staff_number: nil)
      expect(user).not_to be_valid
      expect(user.errors[:student_or_staff_number]).to include("can't be blank")
    end

    it '学籍番号・社員番号が一意であること' do
      create(:user, student_or_staff_number: 123456)
      duplicate_user = build(:user, student_or_staff_number: 123456)
      expect(duplicate_user).not_to be_valid
    end

    it '学籍番号・社員番号が正の整数であること' do
      user = build(:user, student_or_staff_number: -1)
      expect(user).not_to be_valid
    end

    it 'メールアドレスが必須であること' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'メールアドレスが一意であること' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'test@example.com')
      expect(duplicate_user).not_to be_valid
    end

    it 'メールアドレスが大文字小文字を区別しないこと' do
      create(:user, email: 'TEST@example.com')
      duplicate_user = build(:user, email: 'test@example.com')
      expect(duplicate_user).not_to be_valid
    end

    it '正しい形式のメールアドレスのみ許可すること' do
      # 無効なメールアドレス
      invalid_emails = [ 'user@', '@example.com', 'user.example.com' ]
      invalid_emails.each do |invalid_email|
        user = build(:user, email: invalid_email)
        expect(user).not_to be_valid
      end

      # 有効なメールアドレス
      valid_emails = [ 'user@example.com', 'test.user@example.co.jp', 'user+tag@example.com' ]
      valid_emails.each do |valid_email|
        user = build(:user, email: valid_email)
        expect(user).to be_valid
      end
    end

    it 'パスワードが6文字以上であること' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
    end

    it 'パスワードと確認用パスワードが一致すること' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
    end
  end

  # 👥 ロール（役割）のテスト
  describe 'role' do
    it 'デフォルトで学生ロールになること' do
      user = create(:user)
      expect(user.student?).to be true
    end

    it '教職員ロールを設定できること' do
      staff = create(:user, :staff)
      expect(staff.staff?).to be true
      expect(staff.student?).to be false
    end
  end

  # 📧 メールアドレスの正規化テスト
  describe 'email normalization' do
    it 'メールアドレスが小文字で保存されること' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq 'test@example.com'
    end
  end

  # 🔐 パスワード認証のテスト
  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it '正しいパスワードで認証できること' do
      expect(user.authenticate('password123')).to eq user
    end

    it '間違ったパスワードで認証に失敗すること' do
      expect(user.authenticate('wrongpassword')).to be false
    end
  end
end
