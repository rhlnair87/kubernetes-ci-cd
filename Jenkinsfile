node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "mytest"
    imageName = "rhlnair87/mytest:${tag}"
    env.BUILDIMG=imageName

    stage "Test"
    
        sh "sudo docker build -t ${imageName}.test -f applications/nginx-app/Dockerfile.test applications/nginx-app"
        sh "sudo docker run -d --name ${appName}${tag}.test ${imageName}.test"

    stage "Cleanup"
        sh "sudo docker stop ${appName}${tag}.test"
        sh "sudo docker rm ${appName}${tag}.test"
    
    stage "Build"
        sh "sudo docker build -t ${imageName} -f applications/nginx-app/Dockerfile applications/nginx-app"
    
    stage "Push"

        sh "sudo docker push ${imageName}"

    stage "Deploy"
        sh "sed 's#rhlnair87/mytest:latest#'$BUILDIMG'#' applications/nginx-app/k8s/deployment.yaml | kubectl apply --namespace=core-svc -f -"
        sh "kubectl rollout status deployment/mytest --namespace=core-svc"
    stage "Smoke Test"
        //sh "curl http://$(kubectl get svc -n core-svc mytest --output=json | jq -j '.spec.clusterIP')|  grep Hello-Rahul &> /dev/null"
        sh "kubectl get svc -n core-svc mytest --output=json | jq -j '.spec.clusterIP' |  xargs  curl | grep Hello-Rahul"
}
