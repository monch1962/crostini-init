
get_terminal_tools() {
 	sudo apt-get install mosh tmux sshfs -y
}

get_powershell() {
	sudo apt install curl gnupg apt-transport-https liblttng-ust-ctl2 liblttng-ust0 libunwind8 liburcu4 wget
	curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list'
	sudo apt-get update
	sudo apt-get install -y powershell
	sudo apt-get install -f
}
 
get_go() {
    	# [get_golang.sh](https://gist.github.com/n8henrie/1043443463a4a511acf98aaa4f8f0f69)
	# Download latest Golang release for AMD64
	# https://dl.google.com/go/go1.10.linux-amd64.tar.gz

	# set -euf -o pipefail
	# Install pre-reqs
	sudo apt-get install python3 git -y
	o=$(python3 -c $'import os\nprint(os.get_blocking(0))\nos.set_blocking(0, True)')

	#Download Latest Go
	GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
	echo "Finding latest version of Go for AMD64..."
	url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
	latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
	echo "Downloading latest Go for AMD64: ${latest}"
	wget --quiet --continue --show-progress "${url}"
	unset url
	unset GOURLREGEX

	# Remove Old Go
	sudo rm -rf /usr/local/go

	# Install new Go
	sudo tar -C /usr/local -xzf go"${latest}".linux-amd64.tar.gz
	echo "Create the skeleton for your local users go directory"
	mkdir -p ~/go/{bin,pkg,src}
	echo "Setting up GOPATH"
	echo "export GOPATH=~/go" >> ~/.profile && source ~/.profile
	echo "Setting PATH to include golang binaries"
	echo "export PATH='$PATH':/usr/local/go/bin:$GOPATH/bin" >> ~/.profile && source ~/.profile
	echo "Installing dep for dependency management"
	go get -u github.com/golang/dep/cmd/dep

	# Remove Download
	rm go"${latest}".linux-amd64.tar.gz

	# Print Go Version
	/usr/local/go/bin/go version
	python3 -c $'import os\nos.set_blocking(0, '$o')'
}

get_code() {
	# set -euf -o pipefail

	sudo apt-get install gpgconf -y
	sudo apt-get install gpg -y
	curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

	sudo apt-get update -y
	sudo apt-get install code -y
	sudo apt-get install libxss1 libasound2 -y

	code --install-extension ms-vscode.go
	code --install-extension PeterJausovec.vscode-docker
	code --install-extension Zignd.html-css-class-completion
	code --install-extension ecmel.vscode-html-css
	code --install-extension redhat.vscode-yaml
	code --install-extension codezombiech.gitignore
	code --install-extension IBM.output-colorizer
	code --install-extension donjayamanne.git-extension-pack
	code --install-extension formulahendry.docker-extension-pack
	code --install-extension foxundermoon.shell-format
	code --install-extension eamodio.gitlens
	code --install-extension donjayamanne.githistory
	code --install-extension Shan.code-settings-sync
	code --install-extension Equinusocio.vsc-material-theme
	code --install-extension yzhang.markdown-all-in-one
	code --install-extension anseki.vscode-color
	code --install-extension shd101wyy.markdown-preview-enhanced
	code --install-extension PKief.material-icon-theme
	code --install-extension Shan.code-settings-sync
	code --install-extension esbenp.prettier-vscode
	code --install-extension googlecloudtools.cloudcode
	code --install-extension ms-vscode-remote.vscode-remote-extensionpack
	#code --install-extension robertohuertasm.vscode-icons

	code --list-extensions --show-versions	
}

get_docker() {
	sudo apt-get install \
     		apt-transport-https \
     		ca-certificates \
     		curl \
     		gnupg2 \
     		software-properties-common -y

	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

	sudo add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/debian \
   		$(lsb_release -cs) \
   		stable"

	sudo apt-get update
	sudo apt-get install docker-ce -y
	me=`whoami`
	sudo usermod -aG docker ${me}
}

get_node() {
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
	#command -v nvm
	export NVM_DIR="$HOME/.config"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	nvm install node
	npm install -g serverless
}

get_awscli() {
	sudo apt-get install awscli -y
}

get_gcloud() {
	export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
	echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install google-cloud-sdk -y
	sudo apt-get install kubectl -y
}

get_zsh() {
	sudo apt-get install zsh -y
	curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	sh install.sh --unattended
}

get_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

get_skaffold() {
	curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
	chmod +x skaffold
	sudo mv skaffold /usr/local/bin	
	
	# Now get kubectl
	sudo apt-get update && sudo apt-get install -y apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl
	
	# Now get minikube
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
}

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install wget curl bzip2 -y
cd ~
get_terminal_tools
cd ~
get_powershell
cd ~
get_go
cd ~
get_zsh
cd ~
get_rust
cd ~
go get github.com/nsf/gocode
go get github.com/uudashr/gopkgs/cmd/gopkgs
go get github.com/ramya-rao-a/go-outline
go get github.com/acroca/go-symbols
go get golang.org/x/tools/cmd/guru
go get golang.org/x/tools/cmd/gorename
go get github.com/rogpeppe/godef
go get github.com/sqs/goreturns
go get golang.org/x/lint/golint
go get github.com/derekparker/delve/cmd/dlv
get_docker
get_code
get_node
get_awscli
get_gcloud
get_skaffold
