variable "location" {
  type        = string
  description = "The Azure region where resources should be created."
  default     = "canadacentral"
  validation {
    condition     = lower(var.location) == var.location
    error_message = "Azure region vaule must be in all lowercase."
  }
}
variable "env_prefix" {
  type        = string
  description = "Environment prefix to use to label resources in cloud deployment."
  default     = "PRD"
}

variable "vm_prefix" {
  type        = string
  description = "The vm Prefix details of the VM."
  default     = "CE"
}

variable "address_space" {

  type        = string
  description = "The RFC 1918 address space range for the new vnet."
  default     = "10.10.10.0/24"
}

variable "subnets" {
  type = map(any)
  default = {
    subnet_1 = {
      name             = "zone_1"
      address_prefixes = ["10.10.10.0/27"]
    }
  }
}

variable "vm_size" {
  description = "The Virtual Machine Size for the CE VM deployment."
  default     = "Standard_D2ds_v5"
}

variable "admin_username" {
  type        = string
  description = "The Virtual Machine default local admin username for the CE deployment."
  default     = ""
}

variable "trusted_ip" {
  type        = string
  description = "IP address allowed for the configuration and NSG rules."
}

variable "img_sku" {
  type        = string
  description = "Azure Marketplace default image sku"
  default     = "20_04-lts"
}

variable "img_version" {
  type        = string
  description = "Ubuntu version by default the 'latest' available version in the Azure Marketplace is selected"
  default     = "latest"
}
variable "pip" {
  type        = string
  description = "Do you want to assign a Public IP to Access CE? We do not recommend assigning public IP address to Netskope Cloud Exchange, instead connect it by using the Private IP address."
  default     = "No"
  validation {
    condition     = contains(["Yes", "No"], (var.pip))
    error_message = "Valid Values are Yes or No."
  }
}

variable "admin_ssh_key" {
  type        = string
  description = "File Path for the admin public SSH key used to connect to the CE virtual machine, whose format is required to be the openSSH key format with optional comment."
  default     = ""
}

variable "own_cert" {
  type        = string
  description = "Do you want to use your own SSL certificate?"
  default     = "No"
  validation {
    condition     = contains(["Yes", "No"], (var.own_cert))
    error_message = "Do you want to use your own SSL certificate from a Public CA or an inhouse enterprise CA issued SSL certitifcate to use with CE for Web UI access?"
  }
}
variable "tenant_name" {
  type        = string
  description = "Netskope Tenant Name (Exclude .goskope.com), e.g. Enter 'demo' if Netskope Tenant URL is https://demo.goskope.com. Leave to default value of 'test' if you do not have any Netskope tenant."
  default     = "test"
}

variable "ssl_cert" {
  type        = string
  description = "Your Own SSL Certificate File name."
  default     = "cte_cert.crt"
}

variable "ssl_key" {
  type        = string
  description = "Your Own SSL Certificate Private Key File name."
  default     = "cte_cert_key.key"
}

variable "beta_opt_in" {
  type        = string
  description = "Do you want to opt-in for beta?"
  default     = "No"
}

variable "ui_port" {
  type        = string
  description = "Port number to use for the CE web interface."
  default     = "443"
}

variable "jwt_secret" {
  type        = string
  description = "Enter a JWT Secret which will be used for signing the authentication tokens."
  default     = ""
  sensitive   = true
}
variable "maintenance_password" {
  type        = string
  description = "Enter maintenance password that will be used for RabbitMQ and MongoDB services."
  default     = ""
  sensitive   = true
}
