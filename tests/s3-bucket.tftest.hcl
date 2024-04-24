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

run "with_cors" {
    command = apply

    variables {
        name = "casavo-tf-mod-aws-s3-bucket-test"
        cors_rules = [
            {
                allowed_headers = ["*"]
                allowed_methods = ["GET"]
                allowed_origins = ["*"]
                expose_headers  = ["ETag"]
                max_age_seconds = 3000
            },
            {
                allowed_headers = ["*"]
                allowed_methods = ["POST"]
                allowed_origins = ["*"]
                expose_headers  = ["ETag"]
                max_age_seconds = 3000
            },
        ]
    }

    assert {
        condition = length(aws_s3_bucket_cors_configuration.bucket_cors) == 1
        error_message = "bucket cors configuration has not been created"
    }

    assert {
        condition =  length(aws_s3_bucket_cors_configuration.bucket_cors[0].cors_rule) == 2
        error_message = "cors rules should be 2"
    }
}
