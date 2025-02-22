resource "aws_dynamodb_table" "dynamodb_carts" {
  name     = "${var.project_name}-carts"
  hash_key = "id"
  billing_mode = "PAY_PER_REQUEST"
  attribute{
      name = "id"
      type = "S"
    }
  attribute {
      name = "customerId"
      type = "S"
    }

  global_secondary_index{
      name            = "idx_global_customerId"
      hash_key        = "customerId"
      projection_type = "ALL"
    }
}

resource "aws_iam_policy" "carts_dynamo" {
  name        = "${var.project_name}-carts-dynamo"
  path        = "/"
  description = "Dynamo policy for carts application"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllAPIActionsOnCart",
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": [
        "${aws_dynamodb_table.dynamodb_carts.arn}",
        "${aws_dynamodb_table.dynamodb_carts.arn}/index/*",
        "${aws_dynamodb_table.dynamodb_carts.arn}/table/*"
      ]
    }
  ]
}
EOF
}
        # "arn:${local.aws_partition}:dynamodb:${local.aws_region}:${local.aws_account_id}:table/${module.dynamodb_carts.dynamodb_table_id}",
        # "arn:${local.aws_partition}:dynamodb:${local.aws_region}:${local.aws_account_id}:table/${module.dynamodb_carts.dynamodb_table_id}/index/*"