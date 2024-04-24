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

    assert {
        condition = length(aws_s3_bucket_website_configuration.bucket_website) == 0
        error_message = "by default no website configuration should be created"
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

run "website_enabled" {
    command = apply

    variables {
        name = "casavo-tf-mod-aws-s3-bucket-test"
        website_enabled = true
        website_documents = {
            error = "foo.html"
            index = "bar.html"
        }
    }

    assert {
        condition = aws_s3_bucket_website_configuration.bucket_website[0].index_document[0].suffix == "bar.html"
        error_message = "index document is not correct"
    }

    assert {
        condition = aws_s3_bucket_website_configuration.bucket_website[0].error_document[0].key == "foo.html"
        error_message = "error document is not correct"
    }
}