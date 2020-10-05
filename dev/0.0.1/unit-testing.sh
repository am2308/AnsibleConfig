#/bin/bash

#To check whether services running on controller node or not
ControllerIp=$(cat hosts/groups | grep "controller " | awk -F'=' '{print $1}')
ssh -qn ubuntu@$ControllerIp
if ps aux | grep 'kube-api' > /dev/null
then
    echo "Unit-Test-Case-1: Kube-api running on controller node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-1: Kube-api running on controller node or not | Status:  Failed"
    echo -e '\n'
fi
if ps aux | grep 'kube-scheduler' > /dev/null
then
    echo "Unit-Test-Case-2: Kube-scheduler running on controller node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-2: Kube-scheduler running on controller node or not | Status:  Failed"
    echo -e '\n'
fi
if ps aux | grep 'kube-controller' > /dev/null
then
    echo "Unit-Test-Case-3: Kube-controller running on controller node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-3: Kube-controller running on controller node or not | Status:  Failed"
    echo -e '\n'
fi

#To check whether services running on etcd nodes or not
EtcdIp=$(cat hosts/groups | grep "etcd " | awk -F'=' '{print $1}')
ssh -qn ubuntu@$EtcdIp
if ps aux | grep 'etcd' > /dev/null
then
    echo "Unit-Test-Case-4: Etcd service running on etcd node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-4: Etcd service running on etcd node or not | Status:  Failed"
    echo -e '\n'
fi


#To check whether services running on worker0 node or not
Worker0Ip=$(cat hosts/groups | grep "worker0 " | awk -F'=' '{print $1}')
ssh -qn ubuntu@$Worker0Ip
if ps aux | grep 'kubelet' > /dev/null
then
    echo "Unit-Test-Case-5: Kubelet service running on worker0 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-5: Kubelet service running on worker0 node or not | Status:  Failed"
    echo -e '\n'
fi

if ps aux | grep 'kube-proxy' > /dev/null
then
    echo "Unit-Test-Case-6: Kube-proxy service running on worker0 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-6: Kube-proxy service running on worker0 node or not | Status:  Failed"
    echo -e '\n'
fi


#To check whether services running on worker1 node or not
Worker1Ip=$(cat hosts/groups | grep "worker1 " | awk -F'=' '{print $1}')
ssh -qn ubuntu@$Worker1Ip
if ps aux | grep 'kubelet' > /dev/null
then
    echo "Unit-Test-Case-7: Kubelet service running on worker1 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-7: Kubelet service running on worker1 node or not | Status:  Failed"
    echo -e '\n'
fi

if ps aux | grep 'kube-proxy' > /dev/null
then
    echo "Unit-Test-Case-8: Kube-proxy service running on worker1 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-8: Kube-proxy service running on worker1 node or not | Status:  Failed"
    echo -e '\n'
fi



#To check whether services running on worker2 node or not
Worker2Ip=$(cat hosts/groups | grep "worker2 " | awk -F'=' '{print $1}')
ssh -qn ubuntu@$Worker2Ip
if ps aux | grep 'kubelet' > /dev/null
then
    echo "Unit-Test-Case-9: Kubelet service running on worker2 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-9: Kubelet service running on worker2 node or not | Status:  Failed"
    echo -e '\n'
fi

if ps aux | grep 'kube-proxy' > /dev/null
then
    echo "Unit-Test-Case-10: Kube-proxy service running on worker2 node or not | Status:  Passed"
    echo -e '\n'
else
    echo "Unit-Test-Case-10: Kube-proxy service running on worker2 node or not | Status:  Failed"
    echo -e '\n'
fi
