node {

    checkout scm

    env.DOCKER_API_VERSION="1.23"
    
    sh "git rev-parse --short HEAD > commit-id"

    tag = readFile('commit-id').replace("\n", "").replace("\r", "")
    appName = "mytest"
    imageName = "rhlnair87/mytest:${tag}"
    env.BUILDIMG=imageName

    stage "Test"
    
        sh "docker build -t ${imageName}.test -f applications/nginx-app/Dockerfile.test applications/nginx-app"
        sh "docker run -d --name ${appName}${tag}.test ${imageName}.test"

    stage "Cleanup"
        sh "docker stop ${appName}${tag}.test"
        sh "docker rm ${appName}${tag}.test"
    
    stage "Build"
        sh "docker build -t ${imageName} -f applications/nginx-app/Dockerfile applications/nginx-app"
    
    stage "Push"

        sh "docker push ${imageName}"

    stage "Deploy"
        sh "sed 's#rhlnair87/mytest:latest#'$BUILDIMG'#' applications/nginx-app/k8s/deployment.yaml | kubectl apply --namespace=core-svc -f -"
        sh "kubectl rollout status deployment/mytest --namespace=core-svc"
}
