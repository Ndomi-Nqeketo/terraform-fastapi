resource "aws_subnet" "public_subnet" {
    count = var.availability_zones_count

    cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
    vpc_id     = aws_vpc.myvpc.id

    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project}-public-subnet"
        "kubernetes.io/cluster/${var.project}" = "shared"
        "kubernetes.io/role/elb" = "1"
    }
  
}

resource "aws_subnet" "private_subnet" {
    count = var.availability_zones_count

    cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + var.availability_zones_count)
    vpc_id     = aws_vpc.myvpc.id

    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.project}-private-subnet"
        "kubernetes.io/cluster/${var.project}" = "shared"
    }
}