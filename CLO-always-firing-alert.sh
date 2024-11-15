#!/bin/bash
oc project openshift-logging
oc create sa collector -n openshift-logging
oc create clusterrolebinding collect-application-logs --clusterrole=collect-application-logs --serviceaccount openshift-logging:collector
oc create clusterrolebinding collect-infrastructure-logs --clusterrole=collect-infrastructure-logs --serviceaccount openshift-logging:collector
oc create clusterrolebinding collect-audit-logs --clusterrole=collect-audit-logs --serviceaccount openshift-logging:collector
oc adm policy add-cluster-role-to-user logging-collector-logs-writer -z collector
