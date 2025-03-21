provider "aws" {
    region     = "us-east-1"
    access_key = ""
    secret_key = ""
}

resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"

    tags = {
        Name = "public-subnet-1"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_iam_role" "eks_cluster" {
    name = "eks-cluster-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_eks_cluster" "cluster" {
    name     = "high-availability-cluster"
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
        subnet_ids = [aws_subnet.public.id]
    }

    depends_on = [aws_route_table_association.public_assoc]
}
