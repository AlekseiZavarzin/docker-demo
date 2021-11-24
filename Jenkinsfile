def withDockerNetwork(Closure inner) {
  try {
    networkId = UUID.randomUUID().toString()
    sh "docker network create ${networkId}"
    inner.call(networkId)
  } finally {
    sh "docker network rm ${networkId}"
  }
}

pipeline { 	
	agent any
	environment{
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}
    stages {
        stage("Build image") {
            steps {
                sh "docker build -t $DOCKERHUB_CREDENTIALS_USR/petclinic-demo ."
            }
        }
        stage("Test") {
			agent any
			steps {
				script {
					def petclinic = docker.image("$DOCKERHUB_CREDENTIALS_USR/petclinic-demo")
					def tester = docker.image("ubuntu")

					withDockerNetwork{ n ->
						petclinic.withRun("--network ${n} --name petclinic") { c ->
							tester.inside("--network ${n} -u root:root") {
								sh "apt-get update"
								sh "apt-get install -y curl"
								sh "curl http://petclinic:8080"
							}
            			}
          			}
				}
			}
    	}
		stage('Login to Docker hub') {
			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		stage('Push') {
			steps {
				sh 'docker push $DOCKERHUB_CREDENTIALS_USR/petclinic-demo'
			}
		}
	}
	post {
		always {
			sh 'docker logout'
		}
	}
}
