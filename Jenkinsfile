pipeline{
    agent {
        label('a1')
    }
    stages{
        
        stage('Build'){
            steps {
                
                sh 'docker build -t demo:v2 .'
            }
        }
        stage('Test'){
            steps {
                echo ('Hey I am Testing here')
            }
        }
        stage('Deploy'){
            steps {
                echo ('Hey I am Deploying here')
            }
        }
        
    }
    
}
