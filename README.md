# Helm repo

Helm charts are a perfect way to deploy your apps to kubernetes. The downside is that you require
a mechanism to prevent you from duplicating charts projects and keeping them up-to-date.

This project streamlines the way you manage your charts in a central location and reuse them in
all of your projects. We make use of the [s3 plugin](https://github.com/hypnoglow/helm-s3) to store
the charts in a managed solution at a very low cost.

## Usage

The goal is to create one (or a few) repositories that contain multiple charts. By using this project
in your pipeline, you can publish the charts to s3. 

The project will look at any charts found in `/charts` in the container and publish them to the
s3 bucket defined in the `SC_BUCKET` environment variable.

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://com.example.helm/charts \
    stenicbv/helm-s3-repo
```

### AWS credentials

Because you don't want your s3 bucket to be open to the world, you will have to inject your AWS 
credentials into the container. You have the option to inject the `~/.aws` folder together with
the `AWS_PROFILE` you want to select or by injecting your `AWS_ACCESS_KEY_ID` and 
`AWS_SECRET_ACCESS_KEY`. If you are running the container in an AWS environment, you can also make
use of an instance profile to handle authentication. 

__Using your AWS_PROFILE__

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://com.example.helm/charts \
    -v ~/.aws:/root/.aws \
    -e AWS_PROFILE \
    -e AWS_DEFAULT_REGION \
    stenicbv/helm-s3-repo
```

__Using credentials__

```bash
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://com.example.helm/charts \
    -v ~/.aws:/root/.aws \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_DEFAULT_REGION \
    stenicbv/helm-s3-repo
```

## Getting started

### Bucket

To get the project up and running, you will need to create an s3 bucket to push your charts to.
The following is a terraform snippet to create your bucket.

```hcl
resource "aws_s3_bucket" "helm-repo" {
   bucket = "com.example.helm"
   acl    = "private"
}
```

### Repository

Let's setup a repository containing some example charts we want to publish. The location of the 
charts is not as important, as long as the charts are all in the same directory.

```
charts
├── web-application
└── streams-application
```

### Charts pipeline

Now we create a script to publish the charts in the directory. We mount the location where the charts
are to `/charts` in the container and define the `S3_BUCKET`.

```
docker run --rm \
    -v $(pwd)/charts:/charts:ro \
    -e S3_BUCKET=s3://com.example.helm/charts \
    stenicbv/helm-s3-repo
```

### Projects

Now that our charts have been published we can start using them. The implementation in the projects
will be reduced to a minimum.

```
deploy/
├── my-project
│   ├── Chart.yaml
│   └── values.yaml
```

_Chart.yaml_

```
apiVersion: v2
name: my-project
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: 0.1.0
dependencies:
- name: web-application
  version: "0.1.0"
  repository: "s3://com.example.helm/charts"
  alias: app
```

Note `alias` setting. This will set a common prefix to the configuration.

_values.yaml_

```
app:
  image:
    repository: nginx
```

### Deploying a project

As an addition step during the deployment of your app, you will need to make sure the chart
dependency is resolved before you can install the charts.

```bash
helm dependencies update
```

This command will fetch the chart from the central repo.

## Configuration

The project provides a limited set of configuration options.

Parameter | Description | Default
--- | --- | ---
`S3_BUCKET` | The bucket to push the charts to. `s3://com.example.helm/charts` | (Required)
`S3_BUCKET_ACL` | The ACL to apply to any uploaded artifacts | public-read

