
# Adminguide

## Architecture

The LLM infrastructure consists of the following components, users, and interactions including hardware specifications and software versions of a tested and working example setup:
![Components, users, and actions in the LLM infrastructure tech stack](https://i.imgur.com/jjqr3vk.png)

WebUI and API users access the WebUI and the API through the mapped ports of the NGINX gateway. Except for the internal configuration of the WebUI, administration is done via SSH access to the host machine running the Docker containers and possibly by logging into the Docker containers from it. The configuration of individual services and the Docker setup is text-based and can be adjusted using text editors. The internal WebUI configuration is done via the admin account created there.

## Files and Folders

For the setup, the following folders and files with corresponding functions are relevant:
- `setup.sh`
  Script contains everything required for installation or first execution
- `restart.sh`
  Script restarts containers (e.g., to activate configuration changes)
- `docker-compose.yaml`
  Contains Docker container configuration with:
  - container names
  - directories to mount within the container containing configuration files
  - graphics card configuration for the Ollama container
  - activation of the automatic restart in case a container crashes
  - network affiliation of the container
  - environment variables
  - port mappings
  - configuration of the Docker network for the containers
- `ollama/models/*`
  Path for downloaded LLMs (separate folders for LLM manifests and weights), logs, and user data
- `open-webui/*`
  Path for configuration, logs, and user data of the WebUI
- `nginx-gateway/.htpasswd`
  File with login data for the NGINX-based BasicAuth authentication
- `nginx-gateway/cert/`
  Directory for the SSL certificate and private key for HTTPS communication
- `nginx-gateway/conf.d/productive-forwards.conf`
  Contains configuration for NGINX forwarding of connections with:
  - definitions of entry ports and protocols
  - paths to SSL certificate and private key
  - target paths and further settings for incoming network traffic
  - authentication mechanism for direct API requests

## Tasks and Functions

- **Setup**
  - add a SSL key and certificate under `nginx-gateway/cert/` or generate your own via execution of setup script
  - execute the setup script which will add folder structure and may generate SSL key and certificate
- **Create new API users**
  - creating new API users is done in the `.htpasswd` file as part of the NGINX configuration using "htpasswd" (see Files and Folders)
  - `htpasswd /path/to/.htpasswd username` creates a new entry with a username and encrypted password in the .htpasswd and is immediately active without a restart
- **Create new WebUI users**
  - creating new users is done via "Sign Up" function in the login screen of the WebUI
  - in the settings of the admin panel (in the user menu of an admin account) you can:
    - enable or disable the creation of new users via the "Sign Up" function
    - set the default user role for newly registered users ("pending" is recommended to require admin activation of new accounts)
- **Whitelisting of LLMs for inference by users via the WebUI (recommended!)**
  - "Model Whitelisting" can be enabled/disabled in the admin panel
  - without whitelisting, users can download unlimited LLMs from the Ollama-Library
- **Configuration changes to NGINX forwarding**
  - via edit of `productive-forwards.conf` (see Files and Folders)
  - activation of changes requires restart of service or better the entire container
- **Configuration changes to the Docker container setup or the Docker network**
  - via edit of `docker-compose.yaml` (see Files and Folders)
  - activation of changes requires restart of all containers via `restart.sh`
- **Generation of a SSL key and certificate without a CA**
  - insert your own organization parameters in the beginning of the setup script and execute the script
  - !Caution! only for testing purposes, obtain a certificate from a certification authority for production use!
- **Moving the setup to another server**
  - simply copy the folder structure to a new server that meets the requirements and start containers as usual

## Requirements

The entire setup and requirements assume the use of NVIDIA graphics cards for inference. Using AMD graphics cards (ROCm) or CPU-based inference (AVX) is also possible but hasn't yet been considered or tested.
- the following software must be installed:
  - "NVIDIA Drivers"
  - "Docker" and if not already included in Docker, also "Docker Compose"
  - "NVIDIA Container Toolkit" (must be "registered" in Docker after installation, see links)
  - htpasswd (installation via apt: `apt install apache2-utils`)
  - openssl (only necessary for generating a SSL key and certificate without a CA)
- when installing components the sequence above should be preferred
- version notes on software:
  - the software versions defined in architecure figure are confirmed to be working
  - functionality of other versions must be tested accordingly
- to work with a GPU Ollama requires a minimum Compute Capability of 5.0 in its current version (see links)
- port 443 and 8443 need to be free to use on host machine (otherwise adjust port mappings in `docker-compose.yaml` accordingly)

## Notes

- communication between containers is based on Docker hostnames, access via "localhost:port" does not work by design due to lack of port mappings
- when hosting in Kubernetes cluster adjust the number of reserved graphics cards
- currently, containers are restarted when their main process crashes. An unreachable service whose process continues can be detected by additional health checks, but does not lead to a restart. A health-check based restart requires additional scripts or similar and was not implemented for the sake of simplicity.
- for production use, the use of Docker Bench for Security is highly recommended to gain an overview of security-related status of your Docker setup
- for production use, use a SSL certificate issued by a certification authority!

## Links

-	NVIDIA Container Toolkit Installation: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

-	NVIDIA Compute Capability: https://developer.nvidia.com/cuda-gpus

-	Ollama Doku: https://github.com/ollama/ollama/tree/main/docs

-	Ollama Model Library: https://ollama.com/

-	Ollama Discord Server: https://discord.com/invite/ollama

-	Open-WebUI Git: https://github.com/open-webui/open-webui

