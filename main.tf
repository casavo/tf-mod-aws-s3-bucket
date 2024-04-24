locals {
  public_access_block = !var.public

  public_policies = var.public ? [{
    actions = [
      "s3:GetObject"
    ]
    resources  = ["/*"]
    principals = ["*"]
  }] : []

  policylist_bucket = [
    for element in var.bucket_policies : merge(
      {
        actions = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        resources  = [aws_s3_bucket.bucket.arn]
        principals = []
      }, element
    )
  ]

  policylist_resources_struct = concat(local.public_policies, [
    for element in var.resource_policies : merge(
      {
        actions = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]
        resources  = ["/*"]
        principals = []
      },
      element
    )
  ])
  policylist_resources = [
    for element in local.policylist_resources_struct : merge(
      element,
      {
        resources = [
          for path in element["resources"] : "${aws_s3_bucket.bucket.arn}${path}"
        ]
      }
    )
  ]
  policylist_all = concat(local.policylist_bucket, local.policylist_resources)

  lifecycle_policies = [
    for key, element in var.lifecycle_policies : merge(
      {
        id          = key
        prefix      = "/"
        transitions = []
        expirations = []
      }, element
    )
  ]
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.name
  force_destroy = var.force_destroy

  lifecycle {
    ignore_changes = [server_side_encryption_configuration]
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = local.public_access_block
  block_public_policy     = local.public_access_block
  ignore_public_acls      = local.public_access_block
  restrict_public_buckets = local.public_access_block
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count  = length(local.lifecycle_policies) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = local.lifecycle_policies

    content {
      id     = rule.value.id
      status = "Enabled"
      filter {
        prefix = rule.value.prefix
      }

      dynamic "transition" {
        for_each = rule.value.transitions

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expirations

        content {
          days = expiration.value.days
        }
      }
    }
  }

}

data "aws_iam_policy_document" "bucket_policy" {
  dynamic "statement" {
    for_each = local.policylist_all

    content {
      actions   = statement.value.actions
      resources = statement.value.resources

      principals {
        type        = "AWS"
        identifiers = statement.value.principals
      }
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = length(local.policylist_all) > 0 ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json

  depends_on = [
    aws_s3_bucket_public_access_block.bucket
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_ecryption" {
  count = var.encryption.enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.encryption.key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.bucket

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_website" {
  count = var.website_enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = var.website_documents.index
  }

  error_document {
    key = var.website_documents.error
  }
}
