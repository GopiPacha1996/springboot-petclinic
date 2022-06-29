pipeline{
    agent {
        label('a1')
    }
    stages{
        
        stage('Build'){
            steps {
                echo ('docker build -t pet:v2 .')
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
