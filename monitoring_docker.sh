#!/bin/bash

# by Nery Resende (21/11/2018)

# variables
containersName="NAME_CONTAINER" #Lista com o nome dos container a serem monitorados   # NAO DEIXE ESPACO NO INICIO DA VARIAVEL NEM NO FINAL
pluginName="ContainersDocker"
pluginName2="ContainersDockerSemMonitoria"

function containersDocker(){
	erro=0
	for contrunning in $containersName; do
	        status=$(docker inspect $contrunning | grep Status | awk  '{print $2}' | tr -d '" ,')
		if [[ $status = 'running' ]]; then
			erro=$(( $erro + 0))
		else
			erro=$(( $erro + 1))
			instancia="$instancia $contrunning"
		fi
	done
	
	if [ $erro -gt 0 ];then
	       echo "2 $pluginName - [URGENTE] Containers $instancia parados"
	else
		echo "0 $pluginName - Containers $containersName rodando"
	fi
}

function containersDockerSemMonitoria(){
	containersNotMonitoring=$(docker ps -a | grep -v -e IMAGE -e $(echo $containersName | sed -e "s/ / \-e /g") | wc -l)
	containersNameNotMonitoring=$(docker ps -a | grep -v -e IMAGE -e $(echo $containersName | sed -e "s/ / \-e /g") | awk '{print $NF}')
	qtdMonitorados=$(echo $containersName | tr ' ' '\n' | wc -l )
	
	if [ $containersNotMonitoring -ne 0 ];then
		echo "2 $pluginName2 - Os containers $containersNameNotMonitoring nao estao sendo monitorados"
	else
	        echo "0 $pluginName2 - $contrunning containers rodando"
	fi
}

containersDocker
containersDockerSemMonitoria

