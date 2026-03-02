resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-eks-nodes"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": { "Service": "ec2.amazonaws.com" }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_launch_template" "maxpods" {
  name_prefix = "eks-maxpods-"

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

--==BOUNDARY==
Content-Type: application/node.eks.aws

apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  kubelet:
    config:
      maxPods: 6

--==BOUNDARY==--
EOF
  )
}

#resource "aws_eks_node_group" "general" {
#  cluster_name    = aws_eks_cluster.eks.name
#  node_group_name = "general"
#  node_role_arn   = aws_iam_role.nodes.arn
#  subnet_ids      = var.subnet_ids

#  capacity_type = "ON_DEMAND"

#  scaling_config {
#    desired_size = 5
#    max_size     = 5
#    min_size     = 5
#  }

#  instance_types = [var.instance_type]

#  update_config {
#    max_unavailable = 1
#  }

#  labels = {
#    role = "general"
#  }

#  depends_on = [
#    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
#    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
#    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
#  ]

#  launch_template {
#    id      = aws_launch_template.maxpods.id
#    version = tostring(aws_launch_template.maxpods.latest_version)
#  }
#}

# NEW nodegroup
resource "aws_eks_node_group" "general2" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "general2"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general2"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  launch_template {
    id      = aws_launch_template.maxpods.id
    version = tostring(aws_launch_template.maxpods.latest_version)
  }
}

resource "aws_eks_node_group" "monitoring_1a" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-monitoring-1a"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [var.subnet_ids[0]] # ONLY if [0] is eu-central-1a for you

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 3
  }

  instance_types = ["t3.micro"] # or whatever you're using
  capacity_type  = "ON_DEMAND"

  labels = {
    role = "monitoring"
    az   = "eu-central-1a"
  }

  update_config {
    max_unavailable = 1
  }
}
