resource "kubernetes_config_map_v1" "config" {
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
  }

  data = {
    "staticfile.conf" = <<-EOF
      add_header Cache-Control no-cache;

      types {
          ${var.content_type} html;
      }
    EOF
  }
}

resource "kubernetes_config_map_v1" "content" {
  metadata {
    name      = "${var.name}-content"
    namespace = var.namespace
  }

  data = {
    "index.html" = var.content
  }
}

resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.name
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = "nginx"
          image = var.nginx_image

          port {
            container_port = 80
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx/conf.d/staticfile.conf"
            sub_path   = "staticfile.conf"
          }

          volume_mount {
            name       = "content"
            mount_path = "/usr/share/nginx/html"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests = {
              cpu    = "0.25"
              memory = "256Mi"
            }
          }
        }

        volume {
          name = "config"

          config_map {
            name = one(kubernetes_config_map_v1.config.metadata[*].name)
          }
        }

        volume {
          name = "content"

          config_map {
            name = one(kubernetes_config_map_v1.content.metadata[*].name)
          }
        }
      }
    }
  }

  lifecycle {
    replace_triggered_by = [kubernetes_config_map_v1.config]
  }
}
