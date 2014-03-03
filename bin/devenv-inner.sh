#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
	
	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-name mongo \
		-v $APPS/mongo/data:/data/lucid_prod \
		-v $APPS/mongo/logs:/logs \
		-d \
		relateiq/mongo)
	echo "Started MONGO in container $MONGO"

	#MYSQL=$(docker run \
        #        -p 3306:3306 \
	#	-name mysql \
        #        -d \
        #        qtime/mysql bash -c "/start.sh")
        #echo "Started MYSQL in container $MYSQL"

	METEOR=$(docker run \
		-i -t \
                -p 3000:3000 \
		-v /vagrant/code:/root/code \
		-link mongo:db \
		-link mysql:sqldb \
                -d \
                qtime/meteor bash )
        echo "Started METEOR in container $METEOR"

	#SHIPYARD=$(docker run \
	#	-p 8005:8000 \
	#	-d \
	#	shipyard/shipyard)

	#mkdir -p $APPS/redis/data
	#mkdir -p $APPS/redis/logs
	#REDIS=$(docker run \
	#	-p 6379:6379 \
	#	-v $APPS/redis/data:/data \
	#	-v $APPS/redis/logs:/logs \
	#	-d \
	#	relateiq/redis)
	#echo "Started REDIS in container $REDIS"

	sleep 1

}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	#docker pull relateiq/redis
	#docker pull qtime/mysql
	docker pull qtime/meteor
	docker pull relateiq/mongo
	#docker pull shipyard/shipyard
	#docker pull comet/meteor
	#docker pull tutum/mysql
}


case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
