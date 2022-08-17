# Introduction

This Infrastructure as Code (IaC) will help you deploy Netskope Cloud Exchange in your Azure environment and configure the following;

- Create a virtual network and subnet(s).
- Create a Linux VM, associate a System Assigned Managed AAD Identity and bootstrap with the required toolchain to run Netskope Cloud Exchange in Azure e.g. Docker.
- Create a network security group with required rules and associate with the VM network interface. The network security rule is configure to allow communication to cloud exchange admin UI and shell access to the supplied trusted IP(s) i.e., ` var.trusted_ip `.
- Create a Keyvault, secrets, required access policies and set acls to store SSL certificates, if ` var.own_cert ` is set to "Yes".
- Associate a Public IP (not recommended) with the Netskope Cloud Exhange VM, if ` var.pip ` is set to "Yes". 
- Provide Netskope Cloud Exchange IP address as template output value.

## Key Points

- We don't recommend accessing Netskope Cloud Exchange using Public IP but the configuration choice in the code is provided as an option for flexible deployment experience. We recommend accessing the Cloud Exchange using Private IP address either through a Jump/Bastion Host, through the private connectivity (e.g. ExpressRoute or Site to Site Tunnel) or if Netskope Private Access (NPA) is available then through the NPA.

- If you are running this IaC from a system with netskope client with traffic steering to Netskope cloud is enabled and you are also configuring it with your own SSL certificates then you will need to provide an IP address(es) to whitelist in the vitual network security group and azure keyvault ACL. The keyvault firewall ACL will be configured with the supplied CIDR range and it will allow this IaC to upload your SSL certificates to the keyvault without allowing public access to the keyvault. There are few choices you have to supply this IP or CIDR range;

    - Allow the entire Netskope 163.116.128.0/17 range to whitelist.
    - Allow specific IP address range for the Netskope POP you are connecting with, you can find the details of Netskope POP IPs from this support article [NewEdge Point of Presence Global Edge Expansion Status and IP Ranges](https://support.netskope.com/hc/en-us/articles/360035977513). 
    - If you have dedicated Egress IP entitlement from Netskope then you can use your assigned egress IP.
    - You can also run the below command to observe the used egress IP's and perhaps allow those, this option may result in random failures since the egress IP may change.

        ``` sh

        while true; do echo; curl http://notskope.com; sleep 01; done;

        ```

- For a deployment where Public IP is not enabled and you are not using your own SSL certificate, you can provide your private IP address of the Jump/Bastion Host for network security group rule configuration.


Full documentation can be found here: [Netskope Cloud Exchange](https://docs.netskope.com/en/netskope-cloud-exchange.html)

## Architecture Diagram

This IaC will create the Azure resources as shown below, depnding on the input parameter choices e.g. Public IP and Keyvault resources will only be created if you set the input parameter values to Yes.

![](.//images/ce-azure-n.png)

*Fig 1. Netskope Cloud Exchange deployment in Azure*

## Deployment

To deploy this template in Azure:
- Clone the GitHub repository for this deployment.
- Customize variables in the `terraform.tfvars.example` and `variables.tf` file as needed and rename `terraform.tfvars.example` to `terraform.tfvars`.
- Upload SSL certificates to 'certificate' folder, if ` var.own_cert ` is set to "Yes".
- Change to the repository directory and then initialize the providers and modules.

   ```sh
   $ cd <Code Directory>
   $ terraform init
    ```
- Submit the Terraform plan to preview the changes Terraform will make to match your configuration.

   ```sh
   $ terraform plan
   ```
- Apply the plan. The apply will make no changes to your resources, you can either respond to the confirmation prompt with a 'Yes' or cancel the apply if changes are needed.

   ```sh
   $ terraform apply
   ```
- Output will provide Netskope Cloud Exchange ip address to access Netskope's Admin UI.

   ```sh
    Outputs:

    public_ip_address = <Cloud Exchange Public IP> ; if enabled
    private_ip_address = <Cloud Exchange Private IP>

   ```

## Destruction

- To destroy this deployment, use the command:

   ```sh
   $ terraform destroy
   ```

## Support

Netskope-provided scripts in this and other GitHub projects do not fall under the regular Netskope technical support scope and are not supported by Netskope support services.