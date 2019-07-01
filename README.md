Small Terraform Project with 2 tier custom VPC

* Consists of 2 Tiers
- Web tier on a public subnet opened to the internet on HTTP/HTTPS
- Application tier on a private subnet to host DB or AppServers

* Designed with re-usable modules

* WebServers boot strap Apache with a small webpage that states: "This is a webserver"
