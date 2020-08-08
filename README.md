# flutter_firebase

A new Flutter application.

## Set up
https://flutter.dev/docs/get-started/web
```bash
$ flutter channel beta
$ flutter upgrade
$ flutter config --enable-web

# プロジェクト作成
$ flutter create flutter_firebase
$ cd flutter_firebase

# webで起動
$ flutter run -d chrome
```

### Firabase認証トークンの設定
1. トークン取得

```bash
$ firebase login:ci
```

2. GitHub.Secretsに「FIREBASE_TOKEN」として設定する
