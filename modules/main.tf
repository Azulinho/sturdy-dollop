resource "null_resource" "stuff" {
  triggers = {
    cluster_instance_ids = ""
  }

  provisioner "local-exec" {
    command = "echo $(date)"
  }
}
