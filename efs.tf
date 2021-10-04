resource "aws_efs_file_system" "jenkins-home-efs" {
  creation_token = "jenkins-home"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = merge({ Name = "${var.region}-${var.service_name}-jenkins-home-efs" })
}


resource "aws_efs_mount_target" "jenkins-efs-mount-target" {
  count           = 2
  file_system_id  = aws_efs_file_system.jenkins-home-efs.id
  subnet_id       = aws_subnet.jenkins[count.index].id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "jenkins" { #for fargate to mount on
  file_system_id = aws_efs_file_system.jenkins-home-efs.id
  posix_user {
    uid = "1000"
    gid = "1000"
  }
  root_directory {
    path = "/jenkins-home"
    creation_info {
      owner_gid   = "1000"
      owner_uid   = "1000"
      permissions = "755"
    }
  }
}