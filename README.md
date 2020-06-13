# Digital Ocean Playground

Simple server set up to test digital ocean deployment


# Getting Started

1. Install [Docker](https://docs.docker.com/docker-for-mac/install/) and 
	[docker-compose](https://docs.docker.com/compose/install/).
1. Run `docker-compose up` to start web server.
1. Go to [localhost:8080](http://localhost:8080) to view!


# Getting Started with Digital Ocean

1. Create a [Digital Ocean Account](https://cloud.digitalocean.com) and Project
1. Create new Droplet
    * Marketplace > Docker
    * Choose plan of any size
    * (optional) Add volume storage
    * (optional) Select VPC Network
    * Authenticate with SSH key (see #Deploying)
    * Choose any hostname
1. Go to Droplet and document IP address (you'll need that for deploy)

Note: You can destroy the droplet and rebuild at any time.

# Deploying

1. Deploying to Digital Ocean
    1. Generate SSH key on deployment machine.
    1. On [Digital Ocean Security Settings](https://cloud.digitalocean.com/account/security) add SSH key.
    1. Get droplet ip address
    1. On deployment machine add ~/.ssh/config entry with

        ```
        Host {name_for_connection}
            HostName {droplet_ip_address}
            User root
            IdentityFile {your_ssh_key_path}
        ```

    1. Add {name_for_connection} to `scripts/untracked_production/ssh_remote_host.txt` with no return character

1. GitHub Deployment
    1.  Generated [SSH deployment key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
    1. Add to the github project (Settings > Deploy Keys)
    1. Create a folder called `scripts/untracked_production`
    1. Copy deployment key into folder in file `digital_ocean_github_deploy_key_rsa.priv`

1. Deploy
    1. Run `scripts/deploy.sh` to provision and deploy code.
        * Note: Remote matchine must have following which are part of the default Docker droplet
            * git
            * docker
            * docker-compose
