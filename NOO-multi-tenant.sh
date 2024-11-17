#!/bin/bash

htpasswd -c -B -b /tmp/htpass user1 RedHat1
htpasswd -B -b /tmp/htpass user2 RedHat1
htpasswd -B -b /tmp/htpass user3 RedHat1
oc create secret generic htpass-secret --from-file=htpasswd=/tmp/htpass -n openshift-config

cat << EOF |oc apply -f -
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: my_htpasswd_provider
    mappingMethod: claim
    type: HTPasswd
    htpasswd:
      fileData:
        name: htpass-secret
EOF

oc new-project team1 --as=user1 --as-group=system:authenticated --as-group=system:authenticated:oauth 
oc new-project team2 --as=user2 --as-group=system:authenticated --as-group=system:authenticated:oauth 
oc adm policy add-cluster-role-to-user netobserv-reader user1
oc adm policy add-cluster-role-to-user netobserv-reader user2
oc adm policy add-role-to-user netobserv-metrics-reader user1 -n team1
oc adm policy add-role-to-user netobserv-metrics-reader user2 -n team2
oc adm policy add-cluster-role-to-user netobserv-reader user3
oc adm policy add-cluster-role-to-user cluster-monitoring-view user3
oc adm policy add-cluster-role-to-user netobserv-metrics-reader user3
