docker build -t mroobert/multi-client:latest -t mroobert/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mroobert/multi-server:latest -t mroobert/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t mroobert/multi-worker:latest -t mroobert/multi-worker:$SHA -f ./worker/Dockerfile ./worker 

docker push mroobert/multi-client:latest
docker push mroobert/multi-server:latest
docker push mroobert/multi-worker:latest

docker push mroobert/multi-client:$SHA
docker push mroobert/multi-server:$SHA
docker push mroobert/multi-worker:$SHA

kubectl apply -f ./k8s/namespace.yaml
kubectl apply -f ./k8s/resources

kubectl set image deployment/client-deployment client=mroobert/multi-client:$SHA -n $NAMESPACE
kubectl set image deployment/server-deployment server=mroobert/multi-server:$SHA -n $NAMESPACE
kubectl set image deployment/worker-deployment worker=mroobert/multi-worker:$SHA -n $NAMESPACE