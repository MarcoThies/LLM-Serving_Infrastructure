# Adminguide

## Architecture
The LLM infrastructure consists of the following components, users, and interactions including hardware specifications and software versions of a tested and working example setup:
![Components, users, and actions in the LLM infrastructure tech stack](https://i.imgur.com/jjqr3vk.png)
Figure 1: Components, users, and actions in the LLM infrastructure tech stack

WebUI and API users access the WebUI and the API through the mapped ports of the NGINX gateway. Except for the internal configuration of the WebUI, administration is done via SSH access to the host machine running the Docker containers, and possibly by logging into the Docker containers from it. The configuration of individual services and the Docker setup is text-based and can be adjusted using text editors. The internal WebUI configuration is done via the admin account created there.

## Folders and Files
For the setup, the following folders and files with corresponding functions are relevant:
- `setup.sh`
  Script contains everything required for installation or first execution
- `restart.sh`
  Script restarts containers (e.g., to activate configuration changes)
- `docker-compose.yaml`
  Contains Docker container configuration with:
  - Container names
  - Directories to mount within the container containing configuration files
  - Graphics card configuration for the Ollama container
  - Activation of the automatic restart in case a container crashes
  - Network affiliation of the container
  - Environment variables
  - Port mappings
  - Configuration of the Docker network for the containers
- `ollama/models/*`
  Path for downloaded LLMs (separate folders for LLM manifests and weights), logs, and user data
- `open-webui/*`
  Path for configuration, logs, and user data of the WebUI
- `nginx-gateway/.htpasswd`
  File with login data for the NGINX-based BasicAuth authentication
- `nginx-gateway/cert/`
  Directory for the SSL certificate and the private key for HTTPS communication
- `nginx-gateway/conf.d/productive-forwards.conf`
  Contains configuration for the NGINX forwarding of connections with:
  - Definitions of entry ports and protocols
  - Paths to SSL certificate and private key
  - Target paths and further settings for incoming network traffic
  - Authentication mechanism for direct API requests

## Tasks and Functions
- **Setup**
  - Add a private key and SSL certificate under `nginx-gateway/cert/` or generate your own via execution of setup script
  - Execute the setup script
- **Create new API users**
  - Creating new API users is done in the `.htpasswd` file as part of the NGINX configuration using "htpasswd" (see Files and Folders)
  - `htpasswd /path/to/.htpasswd username` creates a new entry with a username and encrypted password in the .htpasswd and is immediately active without a restart
- **Create new WebUI users**
  - Creating new users is done via the "Sign Up" function in the login screen of the WebUI
  - In the settings of the Admin Panel (in the user menu of an admin account), you can:
    - Enable or disable the creation of new users via the "Sign Up" function
    - Set the default user role for newly registered users ("pending" is recommended to require admin activation of new accounts)
- **Whitelisting of LLMs for inference by users via the WebUI (recommended!)**
  - "Model Whitelisting" can be enabled/disabled in the Admin Panel
  - Without whitelisting, users can download unlimited LLMs from the Ollama Library
- **Configuration changes to NGINX forwarding**
  - Via editing the `productive-forwards.conf` (see Folders and Files)
  - Activation of changes requires restarting the service or simply the entire container
- **Configuration changes to the Docker container setup or the Docker network**
  - Via editing the `docker-compose.yaml` (see Folders and Files)
  - Activation of changes requires restarting all containers via `restart.sh`
- **Generation of a private key and issuing a certificate without a CA**
  - Insert your own organization parameters in the openssl command in the setup script and execute the command or script
  - !Caution! Only for testing purposes, obtain a certificate from a certification authority for production use!
- **Moving the setup to another server**
  - Simply copy the folder structure to a new server that meets the requirements and start as usual

## Requirements
The entire setup and requirements assume the use of NVIDIA graphics cards for inference. Using AMD graphics cards (ROCm) or CPU-based inference (AVX) is also possible but has not yet been considered or tested.
- The following software must be installed:
  - "NVIDIA Drivers"
  - "Docker" and if not already included in Docker, also "Docker Compose"
  - "NVIDIA Container Toolkit" (must be "registered" in Docker after installation, see links)
  - htpasswd (e.g., via `apt install apache2-utils`)
  - openssl (only necessary for generating a private key and certificate without a CA)
- When installing components, the order described here should be preferred
- Version notes on software:
  - The versions of the various software visible in Figure 1 work
  - Functionality with other versions must be tested accordingly
  - Limitations may arise from hardware compatibility with Ollama
- Ollama requires a minimum of a 5.0 GPU Compute Capability in the current version (see links)
- Ports 443 and 8443 must be free on the host machine (otherwise, port mappings in `docker-compose.yaml` must be adjusted accordingly)

## Notes
- Communication between containers is based on Docker hostnames, access via "localhost:port" does not work by design due to lack of port mappings
- When hosting in a Kubernetes cluster, adjust or limit the number of reserved graphics cards
- Currently, containers are restarted when their main process crashes. An unreachable service whose process continues can be detected by additional health checks, but does not lead to a restart. A health-check based restart requires additional scripts or similar and was not implemented for the sake of simplicity.
- For production use, the use of Docker Bench for Security is recommended to gain an overview of the security-related status of the Docker setup
- For production use, definitely use an SSL certificate issued by a certification authority!

## Links
-	NVIDIA Container Toolkit Installation: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
-	NVIDIA Compute Capability: https://developer.nvidia.com/cuda-gpus
-	Ollama Doku: https://github.com/ollama/ollama/tree/main/docs
-	Ollama Model Library: https://ollama.com/
-	Ollama Discord Server: https://discord.com/invite/ollama
-	Open-WebUI Git: https://github.com/open-webui/open-webui
