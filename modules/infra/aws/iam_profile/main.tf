resource "aws_iam_role" "rancher_nodes" {
  count = var.create_iam_role ? 1 : 0
  name  = var.iam_role_name != null ? var.iam_role_name : "${var.prefix}-rancher-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rancher_ec2" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.rancher_nodes[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "rancher_nodes" {
  count = var.create_iam_role ? 1 : 0
  name  = aws_iam_role.rancher_nodes[0].name
  role  = aws_iam_role.rancher_nodes[0].name
}
