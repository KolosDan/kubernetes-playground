# Configuring rook-ceph

`cd rook/cluster/examples/kubernetes/ceph`

`kubectl create -f common.yaml`

`kubectl create -f operator.yaml`

`kubectl create -f cluster.yaml`

`kubectl apply -f toolbox.yaml`

`cd ../../../../../`

## Check availability
`kubectl get po -n rook-ceph` - получить имя пода
`kubectl exec <rook_toolbox_pod_name> -n rook-ceph -- ceph status` - проверить статус

```
  cluster:
    id:     9ecbdbff-1d04-4528-81ce-5c7ec8b4d361
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum a,b,c (age 102s)
    mgr: a(active, since 57s)
    osd: 3 osds: 3 up (since 6s), 3 in (since 6s)
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   3.0 GiB used, 1.5 TiB / 1.5 TiB avail
    pgs:   
```

## Create storageclass
`kubectl apply -f storage_config.yaml`

PVC создаются следующим образом:
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-data
  namespace: telemetry
spec:
  storageClassName: rook-ceph-block
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```

PV создается по созданию PVC и удаляется по удалению PVC.