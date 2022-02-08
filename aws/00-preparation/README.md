tfstateを置くS3とロック管理用のdynamodbテーブル作成するCFn

- テンプレートチェック
```
$ aws cloudformation validate-template --template-body file://template.yaml
```

- スタック作成、更新
```
env=dev

# changeset作成
$ aws cloudformation deploy \
  --no-execute-changeset \
  --stack-name terraform-samples-preparation-${env} \
  --region ap-northeast-1 \
  --template-file template.yaml \
  --parameter-overrides Env="${env}" \
  --profile ${env}

bucket名指定する場合
$ aws cloudformation deploy \
  --no-execute-changeset \
  --stack-name terraform-samples-preparation-${env} \
  --region ap-northeast-1 \
  --template-file template.yaml \
  --parameter-overrides Env="${env}" BucketName=megun-terraform-samples-tfstate2-${env} \
  --profile ${env}

# changeset確認
$ aws cloudformation describe-change-set --change-set-name arn:aws:cloudformation:ap-northeast-1:xxxx:changeSet/awscli-cloudformation-package-deploy-xxxxxxx/xxxx-xxxx-xxxx-xxxx-xxxx

# deploy
$ aws cloudformation deploy \
  --stack-name terraform-samples-preparation-${env} \
  --region ap-northeast-1 \
  --template-file template.yaml \
  --parameter-overrides Env="${env}" \
  --profile ${env}
```
