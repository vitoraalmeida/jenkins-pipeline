GRADLE = "./gradlew" //caminho para binário do gradle
DEPENDENCY_TRACK_UPLOAD_URL = "http://192.168.0.103:8081/api/v1/bom"
VERSION_FILE_GRADLE = "./gradle.properties"

properties(
    [
        parameters([
                string(name: 'ORG'),
                string(name: 'PROJECT'),
                choice(
                    choices: ['GRADLE', 'COMPOSER'],
                    name: 'BUILD_TOOL'
                ),
        ])   
    ]
)  

node {
    cleanWs()
    def PROJECT = params.PROJECT
    stage ('clone repos') {
        echo "Clonando ${PROJECT}"
        git branch: 'main', url: "https://github.com/${ORG}/${PROJECT}"
    }

    stage ('execute cyclonedxBom') {
        if (BUILD_TOOL == 'GRADLE') {
            echo "Executando cyclonedxBom em ${PROJECT}"
            sh "${GRADLE} --no-daemon cyclonedxBom -info"
        } else if (BUILD_TOOL == 'COMPOSER') {
            docker.image('composer').inside("-e COMPOSER_HOME=/tmp/jenkins-workspace") {
                stage("Install dependencies") {
                    sh "composer install"
                    sh "composer config --no-plugins allow-plugins.cyclonedx/cyclonedx-php-composer true"
                    sh "composer require --dev cyclonedx/cyclonedx-php-composer"
                }

                stage("generate SBOM") {
                    sh "composer make-bom --exclude-dev"
                }
            }
        } else if (BUILD_TOOL == 'DOCKER')  {
            def image = docker.build("")
            image.inside("") {
                sh "curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin"
            }
        } else {
            echo "Linguagem não suportada"
        }
    }

    stage('publish to dependency track') {
        // recupera a credencial do dependency track e armazena na variável KEY
        withEnv(["URL=${DEPENDENCY_TRACK_UPLOAD_URL}",
                 "ORG=${ORG}",
                 "PROJECT=${PROJECT}",
                 "FILE=${getBomLocation()}",
                 "VERSION=${getVersion()}",]){
            withCredentials([string(credentialsId: 'dtrack', variable: 'KEY')]) {
                sh('curl -X POST -H accept:application/json -H Content-Type:multipart/form-data -H X-API-KEY:$KEY -F autoCreate=True -F projectName=$ORG-$PROJECT -F projectVersion=$VERSION -F bom=@$FILE $URL')
            }
        }
    }
}

def getVersion() {
    if (BUILD_TOOL == 'GRADLE') {
        getVersionGradle()
    } else if (BUILD_TOOL == 'COMPOSER') {
        getVersionComposer()
    } else {
        echo "Linguagem não suportada"
    }
}

def getVersionGradle() {
    def lines = readFile(VERSION_FILE_GRADLE).split("\n")
    def result = "not_found"
    for (line in lines) {
        if (line.contains("version")) {
            result = line.split("=")[1].trim()
        }
    }
    return result.replace(" ","_")
}

def getVersionComposer() {
    return "1.0"
}

def getBomLocation() {
    if (BUILD_TOOL == 'GRADLE') {
        return "./build/reports/bom.xml"
    } else if (BUILD_TOOL == 'COMPOSER') {
        return "./bom.xml"
    } else {
        echo "Linguagem não suportada"
    }
}
