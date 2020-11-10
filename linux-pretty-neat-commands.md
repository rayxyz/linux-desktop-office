# General
## View date & time
```
root@ahezime:~# date
Tue Mar 26 16:36:41 CST 2019
```
## Set timezone
```
root@ahezime:~# cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
## View macheine kernel
```
uname -a
```

## Change to root
```
sudo -i
sudo su -
```

## Remove everything of the current folder
```
ray@ray-pc:~/go_workspace/pkg/linux_amd64$ sudo rm -rf *
```

## Create a folder and grant permissions to current user
```
chmod -R 777 go
sudo chown -R ray go
```
## Processes related
```
ps -ax | grep nginx
```

## Open nautilus with root
gksudo nautilus

## Delete pattern matched files.
```
find /path/to/directory -type f -name '*[0-9]x[0-9]*[0-9]x[0-9]*.jpg' -delete
find /path/to/directory -type f -name '*[0-9]x[0-9]*[0-9]x[0-9]*.jpg' -exec rm {} +
ray@ray-pc:~/go_workspace/src/wholepro$ find ./ -type f -name 'README_*_*.md' -exec rm {} +
```

## View max socket connections
```
ray@ray-pc:~$ ulimit -n
```

## Restart a service
```
sudo systemctl restart apache2
```

## Restart networking
```
/etc/init.d/networking restart
```

## Restart network-manager
```
sudo service network-manager
```

## show line number in vim
```
:set number or :set nu
:set nonumber or :set nonu
```

## comment & uncomment & copy & paste in vim 
comment a block:
```
1. ctl + v
2. arrow to select
3. shift + i
4. #
5. Esc
```

uncomment a block:
```
1. ctl + v
2. arrow to select
3. x
```

copy a block:
```
1. ctl + v or d to cut
2. arrow to select
3. y
```

paste:
```
p
```

## Mout remote server directory by using sshfs
```
sshfs shendu@192.168.1.240:/shendu/bin ~/workspace/trans
sshfs shendu@192.168.1.240:/shendu/bin ~/workspace/trans
```

## Copy ssh public key to remote server.
```
ray@ray:~$ cat ~/.ssh/id_rsa.pub | ssh root@138.197.209.57 'cat >> .ssh/authorized_keys'
```

## Disable ssh public key access and enable password authentication.
```
$> sudo vim /etc/ssh/sshd_config
```
Change PubkeyAuthentication yes to PubkeyAuthentication no
Change PasswordAuthentication no to PasswordAuthentication yes
Restart sshd service
```
$> sudo systemctl restart sshd
```

## Speed up SSH connetion
```
vim /etc/ssh/sshd_config
Change GSSAPIAuthentication yes => GSSAPIAuthentication no
Change GSSAPICleanupCredentials yes => GSSAPICleanupCredentials no
Change UseDNS yes => UseDNS no
```

## Change device name
```
sudo hostname dock-regis-svr
sudo vim /etc/hostname
```

## Count rows of results
```
sudo docker images | tee >(wc -l)
```
### Or
```
sudo docker images | awk '{print} END {print NR}'
```

## Run process in the background by using nohup
```
nohup ./hello &
```

## View directory in tree structure
```
tree dir
```

## View tar.gz file structure
```
tar -tf nsq-1.0.0-compat.linux-amd64.go1.8.tar.gz
```

## netstat
```
sudo netstat -anp | grep :8151
```
view count of connections
```
sudo netstat -anp | grep 1989 | wc -l
30
```
view ESTABLISHED connections count
```
ray@ray-pc:~$ sudo netstat -anp | grep 1989 | grep ESTABLISHED | wc -l
28
```
view TIME_WAIT connections
```
ray@ray-pc:~$ netstat -n | grep -i 1989 | grep -i time_wait | wc -l
8
```

## Aliases
```
INFANTGRPC=$GOPATH/src/infant/vendor/github.com/golang/protobuf/protoc-gen-go
#SDGRPC=$GOPATH/src/shendu.com/vendor/github.com/golang/protobuf/protoc-gen-go
SDGRPC=$GOPATH/bin
MICROGRPC=$GOPATH/src/wholepro/vendor/protoc-gen-go
alias iprotoc='PATH=$PATH:$INFANTGRPC /usr/local/bin/protoc -I . --go_out=plugins=grpc:.'
alias sdprotoc='/usr/local/bin/protoc --plugin=$SDGRPC/protoc-gen-go -I . --go_out=plugins=grpc:.'
alias mprotoc='$GOPATH/src/wholepro/vendor/protoc/protoc --plugin=$MICROGRPC/protoc-gen-go -I . --go_out=plugins=micro:.'
```

## supervisor
```
sudo apt-get install supervisor
```
### create supervisord.conf under dir /etc/supervisor
```
cd /etc/sueprvisor
cp echo_suerpvisord_conf > supervisord.conf
```
### Start supervisor service
```
sudo supervisord
```
### restart service
```
service supervisord.service restart
```

## count rows
```
[root@162 ~]# supervisorctl status  | wc -l
203
```

```
[root@162 ~]# supervisorctl status | grep sd_mobi | wc -l
40
```

## ip
### View ip addresses
```
ip address
```

## Create USB bootable disk (Especially for CentOS)
### Download CentOS image
https://www.centos.org/download/
### unetbootin
https://tecadmin.net/how-to-create-bootable-linux-usb-using-ubuntu-or-linuxmint/#
```
$ sudo add-apt-repository ppa:gezakovacs/ppa
$ sudo apt-get update
$ sudo apt-get install unetbootin
```
### dd ddutility (Very good for USB & SD card reader)
https://github.com/thefanclub/dd-utility
https://www.thefanclub.co.za/how-to/dd-utility-write-and-backup-operating-system-img-and-iso-files-memory-card-or-disk

## After installed centos-7 minimal, set up the network to support networking
```
systemctl enable NetworkManager
systemctl start NetworkManager
nmcli conn show
nmcli conn up <name>
```

## Install openssh-server
### If shows error like, check on the topic `https://askubuntu.com/questions/546983/ssh-installation-errors`
```
sudo apt-get install openssh-server
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 openssh-server : Depends: openssh-client (= 1:7.2p2-4)
                  Depends: openssh-sftp-server but it is not going to be installed
                  Recommends: ssh-import-id but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```
### Then 
```
sudo apt-get install aptitude
```
### And then, install dependencies
```
sudo aptitude install openssh-client=1:7.2p2-4
```
### Finally, you can install openssh-server
```
sudo apt-get install openssh-server
```
### Check ssh server status
```
service sshd status
```

# Shtudown server
```
ray@ray-mini:~$ sudo shutdown -r now
or
sudo poweroff
```

# Open Files Limit
## Max number of open files limit
```
cat /proc/sys/fs/file-max
```
## 
```
lsof | wc -l
```
## ulimit command
### Limit of per process
```
ulimit -n
```
### Soft limit
```
ulimit -Sn
```
### Hard limit
```
ulimit -Hn
```
### See all limits
> ulimit -Sa
```
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 31242
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 31242
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```
> ulimit -Ha
```
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 31242
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1048576
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) unlimited
cpu time               (seconds, -t) unlimited
max user processes              (-u) 31242
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

# SCP
```
scp sd_schoolorg root@192.168.1.164:/shendu/bin
scp username@remote:/file/to/send /where/to/put
scp username@remote_1:/file/to/send username@remote_2:/where/to/put

scp ahezime@45.76.97.215:/root/dbbackups/ahezime_workflow.sql ./ahezime_workflow.sql

<> copy a remote folder to local directory
root@ahezime:~# scp -r root@45.76.97.215:/root/file ./file
```

# Linux service
## list all serices
```
systemctl list-unit-files --type=service
``` 

# Kubernetes related
## Reference
https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
https://kubernetes.io/docs/setup/independent/install-kubeadm/
https://kubernetes.io/docs/tasks/tools/install-kubectl/

## View cluster config
```
kubectl config view
```

## ssh into minikube node
You can ssh into the VM by finding the IP (from kubectl config view) and using username "docker" password "tcuser":
ssh docker@192.168.XX.XX

## Do not forget the following commands show in the `kubeadm init` command result.Run below commands after kubeadm init to start using your cluster, you need to run (as a regular user):
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## If something wrong, you may run the following commands.
```
mkdir /etc/cni/net.d
systemctl start kubelet.service
```

## Expose a service
```
kubectl expose deployment hello-cors-app --type=LoadBalancer --name=hello-cors-app-loadbalancer --external-ip=165.227.17.223 --port=8090
```

## You can view pods healthy status by using comman `kubectl get pods --all-namespaces`, and it can show whether kube-dns and kube-flannel were installed correctly.
```
kubectl get pods --all-namespaces
```

## Join to the master (Notice: you have to make sure you have started docker.service and kubele.serivce, or the slave node join successfully but doesn't show on the master node. And there have chances you may meet the `x509: certificate assigned by unknown authority` issue)
```
kubeadm join --token b301f4.8f335802e86164fe 138.197.197.194:6443 --discovery-token-ca-cert-hash sha256:5de7774e494956996f33aa98a4a543e24fa59b678f150f23b70bc6998c308e8c
```

## Start docker.service and restart kubelet.service
```
systemctl start docker.service
systemctl restart kubelet.service
```

## Solve the nodes notready issue(The issue is produced by pod network in my situation.) Don't use weave-net as the network, just pick up the flannel(I tried, it works.)
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
```

## Solve the creation of pod in pending status issue When You Need to Deploy Apps on the Mater Node.
```
$kubectl create -f hello-cors-app-deploy.yaml
```

```
Events:
  FirstSeen	LastSeen	Count	From			SubObjectPath	Type		Reason			Message
  ---------	--------	-----	----			-------------	--------	------			-------
  38s		7s		7	default-scheduler			Warning		FailedScheduling	No nodes are available that match all of the following predicates:: PodToleratesNodeTaints (1).
```

## Execute the below command and recreate resources to solve the problem.
```
kubectl taint nodes kube-master node-role.kubernetes.io/master:NoSchedule-
```

## Get all pods all namespaces.
```
kubectl --kubeconfig ./admin.conf get pods --all-namespaces -o wide
```

## Remove last kubernetes config
```
rm ~/.kube/config
```

## Tear down (Drain, delete, reset).
```
kubectl drain kube-node-01 --delete-local-data --force --ignore-daemonsets
kubectl delete node kube-node-02
kubeadm reset
```

## View kubelet logs
```
journalctl -u kubelet
```

## View deployment detail information in namespace `default`
```
kubectl get deploy hello-cors-app -n default -oyaml
```

## Run from images
```
kubectl run hiapi --image=ray-xyz.com:9090/hiapi --port=6767
kubectl run hiapix --image=ray-xyz.com:9090/hiapi --labels='app=hiapi'
```

## Scale deployments
```
root@kube-master:~# kubectl scale deployments/com-shendu-service-usercenter-user --replicas=3

```

## Expose deployment to service
```
kubectl expose deployment hiapi --type=NodePort
kubectl expose deployment shendu-service-sdmicro-server --type=NodePort --port=9090 --target-port=9090 --labels='app=shendu-service-sdmicro-server'
```

## Select service by labels
```
kubectl get svc -l='app=hiapi'
```

## Access kubernetes pods from the outside of a cluster (Local test)
### Reference 
https://docs.giantswarm.io/guides/accessing-services-from-the-outside/
```
kubectl port-forward -n default hiapi-1365250305-x8lb2 6767:6767
```

## Minikube ssh into a kubenetes docker machine
```
eval $(minikube docker-env)
eval $(minikube docker-env -u)
docker attach 970939b30548
```

## View pods logs with level(and you can view program running logs. Yeah!!!).
```
kubectl logs -f nginx-ingress-controller-2156363272-f3qfm --v=10
```

## Attach to container in a pod.
```
kubectl exec -it  YOUR_CONTAINER/POD_NAME bash
```

## Describe svc as json format
```
kubectl -n default -ojson get service sdmicro
```

## The simplist way to creat a kubernetes cluster.
1. Create some VPS

2. Install docker.
```
sudo apt-get install docker.io
```

3. Install kubectl.
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```

4. Install kubeadm & kubelet.
```
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm
```

5. Init kubeadm on the master nodes.
```
kubeadm init --pod-network-cidr=10.244.0.0/1
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

6. Add CNI(e.g. => flannel container network interface) on the master nodes.
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

7. Deploy apps
```
kubectl run nginx --image=nginx
kubectl run hiapi --image=ray-xyz.com:9090/hiapi
```

8. Expose services
```
kubectl expose deployment nginx --external-ip=165.227.9.89 --type=LoadBalancer --port=80
kubectl expose deployment hiapi --type=LoadBalancer --external-ip=165.227.9.89 --port=6767
kubectl expose deployment realmicrokube --type=LoadBalancer --external-ip=165.227.16.169 --port=80 --target-port=7878
```

9. Access services outside of cluster.
```
curl http://165.227.9.89
curl http://165.227.9.89:6767
```
or
```
curl http://api.ray-xyz.com/
curl http://api.ray-xyz.com:6767/
```

10. If you encounter problems which are unsolvable of setting up the cluster or you just want to clear everything you have 
setup(Tear down the cluster), just run the following commands.
```
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
kubeadm reset
```

11. View pods and know where are they deployed.
```
root@kube-master:~# kubectl get pods -o wide
NAME                     READY     STATUS    RESTARTS   AGE       IP           NODE
hiapi-1313114994-x0q51   1/1       Running   0          5h        10.244.2.2   kube-slave-02
```

## RBAC Auth
#### If you cannot use kube client api, and the log shows like `2017/09/29 08:00:46 http: panic serving 10.244.0.0:53336: User "system:serviceaccount:default:default" cannot list pods in the namespace "default". (get pods)
`, then you should grant auth to the current role. Eg:
```
touch rbac-default.yaml
sudo vim rbac-default.yaml
#Content =>
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: rbac-default
subjects:
  - kind: ServiceAccount
    # Reference to upper's `metadata.name`
    name: default
    # Reference to upper's `metadata.namespace`
    namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
##
```
Apply the rbac-default.yaml
```
kubectl apply -f rbac-default.yaml
```

## Upgrade the Minikube
```
minikube delete
sudo rm -rf ~/.minikube
```
re-install minikube and it should work

## Access kubernetes service in Minikube cluster
```
minikube service sdmicro
```

## Image pull policy
```
kubectl run sdmicro --image=ray-xyz.com:9090/sdmicro --image-pull-policy=IfNotPresent
```

## Demos
### Deployment
```
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: sdmicro
spec:
  selector:
    matchLabels:
      app: sdmicro
  replicas: 1
  template: # create pods using pod definition in this template
    metadata:
      labels:
        app: sdmicro
    spec:
      containers:
      - name: sdmicro
        image: ray-xyz.com:9090/sdmicro
        ports:
        - containerPort: 7878
        volumeMounts: # For docker in docker, mount host volume to container
        - name: host-docker-volume
          mountPath: /var/run/
        imagePullPolicy: IfNotPresent
      volumes:
      - name: host-docker-volume
        hostPath:
          path: /var/run
```

# Docker related
### Everyday repos
#### MySQL Server CE
sudo docker pull mysql/mysql-server:5.7
sudo docker run --name mysql-server -e MYSQL_ROOT_PASSWORD=123456 mysql/mysql-server:5.7

### Reference
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
https://docs.docker.com/registry/deploying/

## Restart docker
```
systemctl restart docker
```

## Set up a docker registry server on the local network
### Reference
http://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-setup-docker-private-registry-on-centos-7-ubuntu-16-04.html
### Steps to set up local networked docker registry server
```
1. Install docker
2. mkdir -p /certs
2. Create self signed certificate
	openssl req -newkey rsa:4096 -nodes -sha256 -keyout /certs/ca.key -x509 -days 365 -out /certs/ca.crt
4. If the registry server doesn't have the file `/etc/resolv.conf`, then create it.
5. Run the registry server
	docker run -d -p 5000:5000 --restart=always --name registry -v /certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/ca.crt -e REGISTRY_HTTP_TLS_KEY=/certs/ca.key registry:2
6. Copy the /certs/ca.crt from the registry server to docker build client(The machine you work on with docker daemon).
7. Create entry in /etc/hosts
8. Restart the docker engine service on both server and client.
	systemctl restart docker
9. Now, you can work as normal
```

## Run docker registry with external accessible ability
### Reference
```
https://gist.github.com/PieterScheffers/63e4c2fd5553af8a35101b5e868a811e
letsencrypt installing => https://certbot.eff.org/#ubuntuxenial-other
letsencrypt path => /etc/letsencrypt
```

## Docker registry doc
https://docs.docker.com/registry/deploying/

## Run registry container
```
docker run -d --restart=always --name registry -v ~/certs/ray-xyz.com:/certs -v /opt/docker-registry:/var/lib/registry  -e REGISTRY_HTTP_ADDR=0.0.0.0:9090 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key -p 9090:9090 registry:2
```

## Run Docker-in-Docker => dind, mount host volume on container.
```
sudo docker run -v /var/run/:/var/run ray-xyz.com:9090/sdmicro
```

## Login to registry server
```
docker login ray-xyz.com:9090
```

## Working with images
### Pull a base image
```
sudo docker pull ubuntu:16.04
```

### Build an image by using Dockerfile
```
FROM ray-xyz.com:9090/ubuntu1604
MAINTAINER Raywang
ADD bin/consul /usr/local/bin
ENTRYPOINT consul agent -dev
sudo docker build -t ray-xyz.com:9090/consul .
```

### Tag an image
```
docker tag image username/repository:tag => sudo docker tag ubuntu:16.04 ray-xyz.com/ubuntu1604
```

### Push images to ray-xyz.com:9090
```
docker push ray-xyz.com:9090/ubuntu1604
```
### View repositories on registry server
https://www.ray-xyz.com:9090/v2/_catalog

### List repositories on registry server
```
curl --insecure https://localhost:5000/v2/_catalog
```

### Pull a image
```
docker pull ray-xyz.com:9090/ubuntu1604
```

## Stop and remove all containers(commands and bash script)
```
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
```

```
sudo docker rm --force $(sudo docker ps -a | awk '{print $1}')
```

```
#!/bin/bash
containers=($(sudo docker ps -a | awk '{print $2}'))
containerids=($(sudo docker ps -a | awk '{print $1}'))
len_containers=${#containers[@]}
for (( i=1; i<${len_containers}; i++ ));
do
    echo "container id => ${containerids[$i]}, container => ${containers[$i]}"
    if (( "${containers[$i]}" == "usercenter" )); then
        echo "Container usercenter already exists, it will be deleted."
        sudo docker stop ${containerids[$i]}
        sudo docker rm --force ${containerids[$i]}
    fi
done
```

## Delete all images
```
sudo docker image rm $(sudo docker images)
```

## Communication between containers
### View or set ip-forwarding of the host machine
#### View
```
sysctl net.ipv4.conf.all.forwarding
```
#### Set => 1 to true, 0 for false
```
sysctl net.ipv4.conf.all.forwarding=1
```

### The ip_forward setting doesn't affect container when using the host net stack => --net=host
#### Using the network of the host.
```
sudo docker run --net=host ray-xyz.com:9090/hi
```

## View bridge info
```
sudo docker network inspect bridge
```

## View container info
```
sudo docker ps
sudo docker inspect 6f3e8d085c66
```

# Git
## Push local new branch to remote and track
```
git push -u origin <branch>
```

## List configs
```
git config -l
```

## Create a branch and check it out.
```
git checkout -b ray
```

## Ignore some file modified and added it to the .gitignore but still showing under the command `git status`
```
git rm -r --cached github.com/golang/protobuf/protoc-gen-go/protoc-gen-go
```

## Reset add
```
git reset HEAD github.com/golang/protobuf/protoc-gen-go/protoc-gen-go
```

## Reset everything added
```
git reset --hard HEAD^
```

## Reset commit
```
git reset --soft HEAD^
```

## Credential caching
```
git config credential.helper store
```
### With specific time to expire (eg.: 2hrs)
```
git config --global credential.helper 'cache --timeout 7200'
```

## Merge
Merge branches fixes and enhancements on top of the current branch, making an octopus merge:
```
$ git merge fixes enhancements
```

Merge branch obsolete into the current branch, using ours merge strategy:
```
$ git merge -s ours obsolete
```

Merge branch maint into the current branch, but do not make a new commit automatically:
```
$ git merge --no-commit maint
```

## Force checkout branch
```
git checkout -f another-branch
```

## Change the remote
```
git remote
git remote set-url origin git@192.168.1.252:wangrui/sdmicro.git
```

## Forcefully overrite the remote repo with local one
```
git push origin dev -f
```

## Check size of Git proj
```
git count-objects -vH
```

## assume file unchanged(actually it has been changed)
git update-index --assume-unchanged vendor/github.com/golang/protobuf/protoc-gen-go/protoc-gen-go
## and track the changed file again
git update-index --no-assume-unchanged vendor/github.com/golang/protobuf/protoc-gen-go/protoc-gen-go

## Change user.name
```
 git config --global user.name "rayxyz"
```

## Stashing
```
Stashing before switch branches to avoid errors when switch to another branch, but the current changes are not committed.
```
### Stash
```
git stash
```
### Stash list
```
git stash list
```
```
stash@{0}: WIP on ray: d805c16 add user appmodule rel feature
stash@{1}: WIP on ray: d805c16 add user appmodule rel feature
```
### Apply a stash
```
git apply
git apply stash@{1}
git stash pop
```
### Drop a stash
```
git stash drop stash@{0}
```
### Unmerge
```
git merge --abort
```
### Checkout a remote branch
```
git checkout -b newlocalbranchname origin/branch-name

Or

git checkout -t origin/branch-name

The latter will create a branch that is also set to track the remote branch.me
```

# Mysql
## Completely remove MySQL and reinstall mysql-server without backing up.
```
sudo apt-get purge mysql-server mysql-common mysql-client-5.7
sudo rm -rf /var/lib/mysql /etc/mysql/ /var/log/mysql*
sudo apt-get autoremove
sudo apt-get autoclean
```
reboot
  |
  ^
```
sudo apt-get install mysql-server
```
Change some config, restart the service
```
service mysql restart
```
## Chnage TIMEZONE
```
root@raywallake:/ahezime/log# date
Fri Jan 10 09:54:00 UTC 2020
root@raywallake:/ahezime/log# cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
root@raywallake:/ahezime/log# date
Fri Jan 10 17:54:25 CST 2020

> service mysql restart
mysql> select now();
+---------------------+
| now()               |
+---------------------+
| 2020-01-10 17:59:17 |
+---------------------+
1 row in set (0.00 sec)
```

# consul
### Run on local
```
consul agent -dev -enable-script-checks
```

### Run in Docker
```
sudo docker run --net=host ray-xyz.com:9090/consul
```

## Cloning into 'mailman-bundler'... fatal: unable to access 'https://gitlab.com/mailman/mailman-bundler.git/': Problem with the SSL CA cert (path? access rights?)
```
apt-get install ca-certificates
```


# Raspberry PI
## Detect camera is available
```
vcgencmd get_camera
```
If camera is supported and is available, the output should be:
```
supported=1 detected=1
```

## Check if you have expanded the file system
```
df -h
``
output:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  2.4G   12G  18% /
devtmpfs        434M     0  434M   0% /dev
tmpfs           438M     0  438M   0% /dev/shm
tmpfs           438M   12M  427M   3% /run
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           438M     0  438M   0% /sys/fs/cgroup
/dev/mmcblk0p1   42M   22M   20M  53% /boot
tmpfs            88M     0   88M   0% /run/user/1000
```



# OpenCV
## Install OpenCV 2.4.9
```
sudo apt-get install liblapack3 libgfortran3 gcc-5-base=5.3.1-14ubuntu2 libsane libgail18 libgtk2.0-0 libquadmath0 libgphoto2-6 libgnomekbd8 libxklavier16 gir1.2-gtk-3.0 adwaita-icon-theme libcogl20 gstreamer1.0-clutter-3.0 libclutter-gst-3.0-0 gstreamer1.0-plugins-good libcogl-pango20 libcogl-path20 libcogl20 libcogl20 libgl1-mesa-dri libtotem-plparser18 libwayland-egl1-mesa libcapnp-0.5.3 libmircommon7 libcaca0 libtag1v5 libegl1-mesa  libtxc-dxtn-s2tc0 libmircore1 libmirprotobuf3 libprotobuf-lite9v5 libmircore1 libegl1-mesa libqt5svg5 libproxy1v5 libdouble-conversion1v5 gcc-5-base libsoup-gnome2.4-1 librsvg2-2 glib-networking libarchive13 libquvi7 libegl1-mesa libenchant1c2a libgeoclue0 libharfbuzz-icu0 libxslt1.1 libapt-inst2.0 libwebkit2gtk-4.0-37-gtk2 python3-lxml   libimobiledevice6 libplist3 libllvm5.0

sudo apt-get install python-opencv

sudo apt-get install libopencv-objdetect-dev libopencv-highgui-dev libopencv-legacy-dev libopencv-contrib-dev  libopencv-videostab-dev libopencv-superres-dev libopencv-ocl-dev libcv-dev libhighgui-dev libcvaux-dev libopencv-highgui-dev libjasper-dev libjasper1

sudo apt install libopencv-dev
```

## Completely remove OpenCV 2.4.9
```
sudo find / -name "*opencv*" -exec rm -i {} \;
```

## Install OpenCV by Compiling source code
### Install dependencies
```
sudo apt-get install cmake gcc libv4l-dev libtiff-dev libpng12-dev libavutil-dev libavcodec-dev libavfilter-dev libavformat-dev libavdevice-dev libgtk2.0-dev gir1.2-gtk-3.0 pkg-config libgtk-3-0-dbg
sudo apt install python3-dev libpython3.5-dev python3-numpy
```
### Download source code
```
https://github.com/opencv/opencv/releases
or https://github.com/opencv/opencv/archive/3.4.1.tar.gz
```
### Unzip the compressed archive to a directory
```
sudo tar -xzvf 3.4.1.tar.gz -C ~/softs
cd ~/softs/opencv-3.4.1
``
### Build the source code & install
```
sudo mkdir build
cd build
sudo cmake ../
sudo make
sudo make intall
```
### If encounter `-- Looking for sys/videoio.h - not found` in cmake stage
```
sudo cmake -D WITH_V4L=OFF WITH_LIBV4L=OFF INSTALL_C_EXAMPLES=OFF ../
```
### If there are errors when making, remove the build directory and rerun the cmake command
```
sudo rm -rf build
sudo cmake ../
```
### Check if OpenCV is installed correctly
```
#!/usr/bin/env python
import cv2 as cv
print(cv.__version__)
```
### Uninstall OpenCV3.x
```
cd ~/softs/opencv-3.4.1/build
sudo make uninstall
```

# Atom
## clear the $GOPATH/pkg/linux_amd64 to fix the `gocode panic` problem
```
ray@ray-pc:~/go_workspace/pkg/linux_amd64$ sudo rm -rf *
```

# expressvpn open link
```
https://www.exp2links2.net/latest?utm_source=linux_app
```

# iptables
## List all rules
```
sudo iptables -L
```
## List all rules with bytes
```
sudo iptables -L -v
```

# OpenVPN
## Set up OpenVPN server
```

```

## Change subnet mask
```
https://superuser.com/questions/933938/openvpn-how-can-i-assign-specific-netmask-for-clients-from-server-side
```

## IP forwarding
```
https://arashmilani.com/post?id=53
```

## Install OpenVPN client plugin to import .ovpn config file
```
sudo apt install network-manager-openvpn-gnome
```

# iptables
## View iptables rules
```
iptables -L
iptables -L -v
```
root@vpn:~# iptables -L -v
Chain INPUT (policy ACCEPT 44 packets, 4097 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    1   173 ACCEPT     udp  --  eth0   any     anywhere             anywhere             state NEW udp dpt:openvpn
   10   840 ACCEPT     all  --  tun0   any     anywhere             anywhere            

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ACCEPT     all  --  tun0   any     anywhere             anywhere            
    0     0 ACCEPT     all  --  tun0   eth0    anywhere             anywhere             state RELATED,ESTABLISHED
    0     0 ACCEPT     all  --  eth0   tun0    anywhere             anywhere             state RELATED,ESTABLISHED

Chain OUTPUT (policy ACCEPT 38 packets, 4030 bytes)
 pkts bytes target     prot opt in     out     source               destination         
   10   840 ACCEPT     all  --  any    tun0    anywhere             anywhere       
```
iptables -t filter -L -v
iptables -t nat -L
```
## delete rules
```
sudo iptables -L --line-numbers
sudo iptables -D INPUT 3
```

## iptables-save > iptables.rules
```
# Generated by iptables-save v1.6.0 on Fri Nov  2 04:44:55 2018
*nat
:PREROUTING ACCEPT [699:51779]
:INPUT ACCEPT [603:32675]
:OUTPUT ACCEPT [145:9957]
:POSTROUTING ACCEPT [145:9957]
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT
# Completed on Fri Nov  2 04:44:55 2018
# Generated by iptables-save v1.6.0 on Fri Nov  2 04:44:55 2018
*filter
:INPUT ACCEPT [1344:204577]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [1496:283700]
-A INPUT -i eth0 -p udp -m state --state NEW -m udp --dport 1194 -j ACCEPT
-A INPUT -i tun0 -j ACCEPT
-A FORWARD -i tun0 -j ACCEPT
-A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -o tun0 -j ACCEPT
COMMIT
# Completed on Fri Nov  2 04:44:55 2018
```

## iptables-restore < iptables.rules


# Socks Proxy
## open the proxy
```
ssh -D 12345 root@104.248.221.14
```

# install uninstalled libs after show up errors of installing other softwares
```
sudo apt-get -f install
```

# Install nginx
```
sudo apt-get update
sudo apt-get install nginx
```

# ufw
```
sudo ufw enable

sudo ufw disable

sudo ufw status

sudo ufw allow ssh

sudo ufw allow 3306

sudo ufw app list

sudo ufw allow 'Nginx Full'
```

# curl
```
curl -lk --resolve ahezime.com:443:159.65.73.232 https://ahezime.com/common/v1/country_code/list
```

# Use socks5 HTTPs proxy to run `go` command
[https://stackoverflow.com/questions/10383299/how-do-i-configure-go-command-to-use-a-proxy](https://stackoverflow.com/questions/10383299/how-do-i-configure-go-command-to-use-a-proxy)
Don't use any proxy
```
ray@ray-pc:~/workspace/ahezime.com/ahezime$ go test
go: finding rsc.io/quote v1.5.2
go: downloading rsc.io/quote v1.5.2
verifying rsc.io/quote@v1.5.2: rsc.io/quote@v1.5.2: Get https://sum.golang.org/lookup/rsc.io/quote@v1.5.2: dial tcp 216.58.200.49:443: i/o timeout
```
Cannot download go packages, blocked.

You cannot use proxychains, because `go` command doesn't use libc:
```
proxychains go test
ProxyChains-3.1 (http://proxychains.sf.net)
go: downloading rsc.io/quote v1.5.2
verifying rsc.io/quote@v1.5.2: rsc.io/quote@v1.5.2: Get https://sum.golang.org/lookup/rsc.io/quote@v1.5.2: dial tcp 216.58.200.49:443: i/o timeout
```

Finally, `go` can use http proxy, I try the command `HTTPS_PROXY=socks5://127.0.0.1:1080 go test`, it works. Here I use
SSR socks5 proxy to proxy `go` command.
```
ray@ray-pc:~/workspace/ahezime.com/ahezime$ HTTPS_PROXY=socks5://127.0.0.1:1080 go test
go: downloading rsc.io/quote v1.5.2
go: extracting rsc.io/quote v1.5.2
go: downloading rsc.io/sampler v1.3.0
go: extracting rsc.io/sampler v1.3.0
go: downloading golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c
go: extracting golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c
go: finding rsc.io/sampler v1.3.0
go: finding golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c
PASS
ok  	ahezime.com/ahezime	0.001s
```



# USB-WiFi driver install

Instructions:
```
sudo apt purge rtl8812au-dkms
sudo apt install git
git clone https://github.com/gnab/rtl8812au.git
sudo cp -r rtl8812au /usr/src/rtl8812au-4.2.2
sudo dkms add -m rtl8812au -v 4.2.2
sudo dkms build -m rtl8812au -v 4.2.2
sudo dkms install -m rtl8812au -v 4.2.2
```

## Reference
https://rehmann.co/blog/drivers-wifi-usb-adapter-osxmac-linux-windows/

# Fix Linux GUI frozen
https://www.fosslinux.com/39434/5-things-to-do-when-your-linux-system-gui-freezes.htm
