# 最初に
- S3にtfstateのバケット作成しておく

# workspace作成
```
$ cd 01_VPC
$ terraform workspace new dev
$ terraform workspace new prd
```

# 初期設定(必要モジュールダウンロードとか)
```
$ cd 01_VPC
$ terraform init
```

# 実行
```
$ cd 01_VPC
$ terraform workspace select dev
$ terraform plan
$ terraform apply

$ terraform workspace select prd
$ terraform plan
$ terraform apply
```
