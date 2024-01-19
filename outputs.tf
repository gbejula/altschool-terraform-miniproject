output "vpc_id" {
    value = aws_vpc.tera_vpc.id
}

output "elb_load_balancer_dns_name" {
    value = aws_lb.tera-load-balancer.dns_name
}