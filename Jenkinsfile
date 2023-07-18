pipeline{

    agent any

    stages{
        stage('Checkout the code'){
            steps{
                git branch: 'main',  url: 'https://github.com/skmdab/create_tomcat.git'
            }
        }

        stage('Creating server'){
            steps{
                sh "sh aws_create.sh"
            }
        }

        stage('Installing tomcat package into server'){
            steps{
                withCredentials([file(credentialsId: 'pemfile', variable: 'PEMFILE')]) {
                 sh 'ansible-playbook installtomcat.yaml --private-key="$PEMFILE"'
                }
               
            }
        }
    }
}
