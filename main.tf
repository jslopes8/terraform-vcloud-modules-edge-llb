resource "vcd_lb_virtual_server" "lb" {

    name            = "lb-${var.name}"
    edge_gateway    = var.edge_gateway
    ip_address      = var.ip_address
    protocol        = var.protocol
    port            = var.port

    #app_profile_id = vcd_lb_app_profile.lb_profile.id[0]
    server_pool_id = vcd_lb_server_pool.lb_pool.id
    #app_rule_ids   = [ "${vcd_lb_app_rule.redirect.id}" ]
}

resource "vcd_lb_service_monitor" "lb_health_check" {
    count   = var.create ? length(var.health_check) : 0

    edge_gateway = var.edge_gateway

    name        = var.health_check[count.index]["name"]
    interval    = lookup(var.health_check[count.index], "interval", null)
    timeout     = lookup(var.health_check[count.index], "timeout", null)
    max_retries = lookup(var.health_check[count.index], "max_retries", null)
    type        = lookup(var.health_check[count.index], "type", var.protocol)
    method      = lookup(var.health_check[count.index], "method", null)
    url         = lookup(var.health_check[count.index], "url", null)
    send        = lookup(var.health_check[count.index], "send", null)
    #extension = {
    #    content-type = "application/json"
    #    linespan     = ""
    #}
}

resource "vcd_lb_server_pool" "lb_pool" {
    edge_gateway = var.edge_gateway

    monitor_id = vcd_lb_service_monitor.lb_health_check.0.id

    name                 = "lb-pool-${var.name}"
    algorithm            = var.algorithm
    algorithm_parameters = var.algorithm_parameters
    enable_transparency  = var.enable_transparency

    dynamic "member" {
        for_each    = var.member
        content {
            condition       = member.value.condition
            name            = member.value.name
            ip_address      = member.value.ip_address
            port            = member.value.port
            monitor_port    = member.value.monitor_port
            weight          = member.value.weight
            min_connections = member.value.min_connections
            max_connections = member.value.max_connections
        }
    }
}

resource "vcd_lb_app_profile" "lb_profile" {
    count   = var.create ? length(var.profile) : 0
    
    edge_gateway = var.edge_gateway
    name = "lb-profile-${var.name}"
    type = var.protocol

    http_redirect_url              = lookup(var.profile[count.index], "http_redirect_url", null)
    enable_pool_side_ssl           = lookup(var.profile[count.index], "enable_pool_side_ssl", null)
    persistence_mechanism          = lookup(var.profile[count.index], "persistence_mechanism", null)
    cookie_name                    = lookup(var.profile[count.index], "cookie_name", null)
    cookie_mode                    = lookup(var.profile[count.index], "cookie_mode", null)
    insert_x_forwarded_http_header = lookup(var.profile[count.index], "insert_x_forwarded_http_header", null)
}