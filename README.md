# Helm repo

Enable automated management of a private s3 helm repository.

## Usage

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://io.stenic.helm/charts \
    stenic/helm-repo
```

### AWS credentials

Using your AWS_PROFILE

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://io.stenic.helm/charts \
    -v ~/.aws:/root/.aws \
    -e AWS_PROFILE \
    stenic/helm-repo
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
    stenic/helm-repo
```

