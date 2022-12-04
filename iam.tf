resource "aws_iam_group" "administrator" {
  name = "Administrator"
}

resource "aws_iam_group_policy_attachment" "policy_attach" {
  group      = aws_iam_group.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}

resource "aws_iam_user" "admin_users" {
  count = length(var.admin_users)
  name  = element(var.admin_users, count.index)
  # tags  = var.tags
}

resource "aws_iam_user_group_membership" "grp_mem" {
  count = length(var.admin_users)
  user  = element(var.admin_users, count.index)
  groups = [
    aws_iam_group.administrator.name
  ]
  depends_on = [
    aws_iam_user.admin_users
  ]
}

# account alias
resource "aws_iam_account_alias" "alias" {
  account_alias = var.iam_account_alias
}
