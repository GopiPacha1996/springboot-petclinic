output "image_details" {
    value = data.aws_ami.my-image.id
}

output "ip" {
    value = aws_instance.demoinstance.public_ip
}