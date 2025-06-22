.PHONY: setup init up upd build down restart logs shell console test migrate reset install clean help

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  make setup     - 初回セットアップ（ビルド + 初期化 + 起動）"
	@echo "  make init      - Railsアプリを初期化（初回のみ実行）"
	@echo "  make up        - コンテナを起動（フォアグラウンド）"
	@echo "  make upd       - コンテナを起動（バックグラウンド）"
	@echo "  make build     - コンテナをビルドして起動"
	@echo "  make down      - コンテナを停止・削除"
	@echo "  make restart   - コンテナを再起動"
	@echo "  make logs      - ログを表示"
	@echo "  make shell     - webコンテナに入る"
	@echo "  make console   - Rails コンソールを起動"
	@echo "  make test      - テストを実行"
	@echo "  make migrate   - マイグレーションを実行"
	@echo "  make reset     - データベースをリセット"
	@echo "  make install   - Gemをインストール"
	@echo "  make clean     - 未使用のイメージ・ボリュームを削除"

# コンテナ起動
up:
	docker compose up

upd:
	@echo "🚀 コンテナを起動します..."
	docker compose up -d

# ビルドして起動
build:
	docker compose up --build -d

# コンテナ停止
down:
	@echo "🚀 コンテナを停止します..."
	docker compose down

# 再起動
restart:
	docker compose restart

# ログ表示
logs:
	docker compose logs -f

# webコンテナに入る
b:
	docker compose exec web bash

# Rails コンソール
console:
	docker compose exec web rails console

# テスト実行
test:
	docker compose exec web rspec

# マイグレーション
migrate:
	docker compose exec web rails db:migrate

# データベースリセット
reset:
	docker compose exec web rails db:reset

# Gemインストール
install:
	docker compose exec web bundle install

# Railsアプリ初期化（初回のみ）
init:
	@echo "🚀 Railsアプリケーションを初期化します..."
	docker compose run --rm web rails new . --api --database=postgresql --skip-git --force
	docker compose run --rm web rails db:create
	docker compose run --rm web rails db:migrate
	@echo "✅ 初期化完了！ 'make up' でサーバーを起動してください"

# 初回セットアップ（新規プロジェクト用）
setup:
	@echo "🚀 初回セットアップを開始します..."
	@echo "1️⃣ コンテナをビルド中..."
	docker compose build
	@echo "2️⃣ Railsアプリケーションを作成中..."
	docker compose run --rm web rails new . --api --database=postgresql --skip-git --force
	@echo "3️⃣ データベースを作成中..."
	docker compose run --rm web rails db:create
	docker compose run --rm web rails db:migrate
	@echo "4️⃣ サーバーを起動中..."
	@echo "✅ セットアップ完了！ http://localhost:3000 でアクセスできます"
	@echo "   停止するには Ctrl+C を押してください"
	docker compose up

# クリーンアップ
clean:
	docker system prune -f
	docker volume prune -f
