pipeline{
	agent any
	environment{
        DOCKERHUB_USERNAME="alexzavr"
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}

	stages {
		stage('Build') {
			steps {
				sh 'docker build -t $DOCKERHUB_USERNAME/petclinic-demo .'
			}
		}
		stage('Login') {
			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		stage('Push') {
			steps {
				sh 'docker push $DOCKERHUB_USERNAME/petclinic-demo'
			}
		}
	}

	post {
		always {
			sh 'docker logout'
		}
	}
}