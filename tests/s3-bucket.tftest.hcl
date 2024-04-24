run "create_bucket" {
    command = apply

    variables {
        name = "casavo-tf-mod-aws-s3-bucket-test"
    }

    assert {
        condition = aws_s3_bucket.bucket.bucket == "casavo-tf-mod-aws-s3-bucket-test"
        error_message = "bucket name is not correct"
    }

    assert {
        condition = length(aws_s3_bucket_cors_configuration.bucket_cors) == 0
        error_message = "bucket cors configuration has been created"
    }
}
