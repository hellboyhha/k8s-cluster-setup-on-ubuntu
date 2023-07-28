#!/bin/bash

function worker_join(){

        # copy required scripts to worker node

        echo -e "\n***** Copy required script files to $2. Please, provide the password of $1 in $2. *****\n"
        sleep 5
        scp cleanup_old_packages_files.sh containerd_install_$3.sh k8s_install.sh $1@$2:~
        sleep 3

        # clean up old packages and files
        echo -e "\n***** Clean Up old packages and files at $2. Please, provide the password of $1 in $2. *****\n"
        sleep 5
        ssh -t $1@$2 "cd $HOME && ./cleanup_old_packages_files.sh"
        sleep 3

        # containerd installation on worker node
        echo -e "\n***** Containerd Installation at $2. Please, provide the password of $1 in $2. *****\n"
        sleep 5
        ssh -t $1@$2 "cd $HOME && ./containerd_install_$3.sh"
        sleep 3

        # k8s installation on worker node
        echo -e "\n***** K8S Installation at $2. Please, provide the password of $1 in $2. *****\n"
        sleep 5
        ssh -t $1@$2 "cd $HOME && ./k8s_install.sh"
        sleep 3


}

function main(){

        worker_join $1 $2 $3

}

main $1 $2 $3
