# Campus Reserve - 学校施設予約システム

Campus Reserveは、学校施設のオンライン予約を可能にするWebアプリケーションです。Ruby on Railsを使用して構築されており、RESTful設計、MVCアーキテクチャ、CRUD機能を実装しています。

## 主な機能

### 施設管理（Facilities）
- 施設の一覧表示
- 施設の詳細表示
- 施設の新規登録
- 施設情報の編集
- 施設の削除
- 施設の利用可能状態管理

### 予約管理（Reservations）
- 予約の一覧表示
- 予約の詳細表示
- 予約の新規登録
- 予約情報の編集
- 予約の削除
- 予約ステータス管理（承認待ち、確定、キャンセル）
- 重複予約の防止

## 技術スタック

- **Ruby**: 3.2.3
- **Rails**: 8.1.1
- **Database**: SQLite3（開発環境）
- **UI**: ERB テンプレート（インラインCSS）
- **国際化**: 日本語対応（i18n）

## システム要件

- Ruby 3.2.3以上
- Bundler 2.0以上
- SQLite3

## セットアップ手順

### 1. リポジトリのクローン
```bash
git clone https://github.com/hirakazu0607/Campus_Reserve.git
cd Campus_Reserve
```

### 2. 依存関係のインストール
```bash
bundle install --path vendor/bundle
```

### 3. データベースのセットアップ
```bash
# データベース作成
bundle exec rails db:create

# マイグレーション実行
bundle exec rails db:migrate

# サンプルデータの投入（オプション）
bundle exec rails db:seed
```

### 4. アプリケーションの起動
```bash
bundle exec rails server
```

ブラウザで http://localhost:3000 にアクセスしてください。

## テストの実行

```bash
bundle exec rails test
```

すべてのテストが成功することを確認してください。

## データベース構造

### Facilities（施設）
- `name`: 施設名（必須、ユニーク）
- `description`: 説明
- `capacity`: 収容人数（必須、正の整数）
- `available`: 利用可能フラグ

### Reservations（予約）
- `facility_id`: 施設ID（外部キー）
- `user_name`: 予約者名（必須）
- `user_email`: メールアドレス（必須、メール形式）
- `start_time`: 開始時刻（必須）
- `end_time`: 終了時刻（必須、開始時刻より後）
- `purpose`: 利用目的（必須）
- `status`: ステータス（pending/confirmed/cancelled）

## RESTful設計

本アプリケーションは、Railsの規約に従ったRESTfulな設計を採用しています：

### Facilities（施設）のルート
- `GET /facilities` - 施設一覧
- `GET /facilities/new` - 施設登録フォーム
- `POST /facilities` - 施設作成
- `GET /facilities/:id` - 施設詳細
- `GET /facilities/:id/edit` - 施設編集フォーム
- `PATCH/PUT /facilities/:id` - 施設更新
- `DELETE /facilities/:id` - 施設削除

### Reservations（予約）のルート
- `GET /reservations` - 予約一覧
- `GET /reservations/new` - 予約登録フォーム
- `POST /reservations` - 予約作成
- `GET /reservations/:id` - 予約詳細
- `GET /reservations/:id/edit` - 予約編集フォーム
- `PATCH/PUT /reservations/:id` - 予約更新
- `DELETE /reservations/:id` - 予約削除

## サンプルデータ

初期データとして以下の施設が登録されています：
- 大講義室（300名）
- 中講義室A（100名）
- 中講義室B（100名）
- 小会議室（20名）
- 体育館（500名）
- コンピューター室（50名）
- 音楽室（30名）
- 図書館ホール（80名）

## アーキテクチャ

本アプリケーションはMVCアーキテクチャに基づいています：

- **Model**: データベースとのやり取り、ビジネスロジック、バリデーション
- **View**: ユーザーインターフェース（ERBテンプレート）
- **Controller**: リクエストの処理、モデルとビューの橋渡し

## バリデーション

### Facility（施設）
- 施設名は必須かつユニーク
- 収容人数は必須かつ正の整数

### Reservation（予約）
- 予約者名とメールアドレスは必須
- メールアドレスは正しい形式
- 開始時刻と終了時刻は必須
- 終了時刻は開始時刻より後
- 利用目的は必須
- 同じ施設で時間が重複する予約は不可

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。

## 開発者

hirakazu0607

## サポート

問題が発生した場合は、GitHubのIssueセクションで報告してください。
