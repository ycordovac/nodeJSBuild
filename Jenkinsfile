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

  environment {
    registryCredential='yandihlg'
    registryFrontend = 'yandihlg/angular-14-app'
  }

  stages {
    stage('Build') {
      steps {
        sh 'npm install'
        sh 'npm run build &'
        sleep 20
        sh 'ls -la'
        sh 'cd src'
        sh 'ls -la'
      }
    }

    stage('Push Image to Docker Hub') {
      steps {
        script {
          dockerImage = docker.build registryFrontend + ":$BUILD_NUMBER"
          docker.withRegistry( '', registryCredential) {
            dockerImage.push()

          }

        }

      }

    }



    stage('Push Image latest to Docker Hub') {
      steps {
        script {
          dockerImage = docker.build registryFrontend + ":latest"
          docker.withRegistry( '', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }



    stage('Deploy to K8s') {
      steps{
        script {
          if(fileExists("configuracion")){
            sh 'rm -r configuracion'
          }
        }
        sh 'git clone https://github.com/ycordovac/kubernetes-helm-docker-config.git configuracion --branch test-implementation'
        sh 'kubectl apply -f configuracion/kubernetes-deployment/angular-14-app/manifest.yml -n default --kubeconfig=configuracion/kubernetes-config/config'
      }
    }

    stage ("Run API Test") {
            steps{
                node("node-nodejs"){
                    script {
                        if(fileExists("spring-boot-app")){
                            sh 'rm -r spring-boot-app'
                        }
                        sh 'git clone https://github.com/ycordovac/spring-boot-app.git spring-boot-app --branch api-test-implementation'
                        sh 'newman run spring-boot-app/src/main/resources/bootcamp.postman_collection.json --reporters cli,junit --reporter-junit-export "newman/report.xml"'
                        junit "newman/report.xml"

                    }

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

