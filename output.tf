output "key-pair" {
    value = aws_key_pair.deployer.key_name
}
output "sg" {
    value = aws_security_group.allow_ssh.id
}
output "lc" {
    value = aws_launch_configuration.as_conf.name
}