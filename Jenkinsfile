pipeline{
  agent {
    kubernetes {
        yaml '''

apiVersion: v1
kind: Pod
spec:
  containers:
  - name: shell
    image: yandihlg/jenkins-nodo-nodejs-bootcamp:latest
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-socket-volume
    securityContext:
      privileged: true
  volumes:
  - name: docker-socket-volume
    hostPath:
      path: /var/run/docker.sock
      type: Socket
    command:
    - sleep
    args:
    - infinity
        '''
        defaultContainer 'shell'
      }
  }
    stages {

        stage ("Run API Test") {
            steps{
                script {
                    if(fileExists("spring-boot-app")){
                        h 'rm -r spring-boot-app'
                    }
                    sh 'git clone https://github.com/ycordovac/spring-boot-app.git spring-boot-app --branch inicial'
                    sh 'newman run spring-boot-app/src/main/resources/bootcamp.postman_collection.json --reporters cli,junit --reporter-junit-export "newman/report.xml"'
                    junit "newman/report.xml"

                }
            }
        }
    }

  post {
    always {
      sh 'docker logout'
    }
  }
}
