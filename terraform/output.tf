output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins_server.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_public_dns" {
  value = aws_instance.jenkins_server.public_dns
}
