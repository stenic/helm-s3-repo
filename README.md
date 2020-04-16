# Helm repo

Enable automated management of a private s3 helm repository.

## Usage

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://io.stenic.helm/charts \
    stenicbv/helm-s3-repo
```

### AWS credentials

Using your AWS_PROFILE

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://io.stenic.helm/charts \
    -v ~/.aws:/root/.aws \
    -e AWS_PROFILE \
    -e AWS_DEFAULT_REGION \
    stenicbv/helm-s3-repo
```

Using your credentials

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://io.stenic.helm/charts \
    -v ~/.aws:/root/.aws \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_DEFAULT_REGION \
    stenicbv/helm-s3-repo
```

## Configuration

Parameter | Description | Default
--- | --- | ---
`S3_BUCKET` | The bucket to push the charts to. `s3://io.stenic.helm/charts` | (Required)
`S3_BUCKET_ACL` | The ACL to apply to any uploaded artifacts | public-read

