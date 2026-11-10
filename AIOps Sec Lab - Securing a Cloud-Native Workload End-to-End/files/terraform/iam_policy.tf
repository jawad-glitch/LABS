data "aws_iam_policy_document" "shop_api" {
  statement {
    sid       = "ListOrdersPrefix"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.orders.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["orders/*"]
    }
  }
  statement {
    sid       = "ReadWriteOrders"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.orders.arn}/orders/*"]
  }
}
