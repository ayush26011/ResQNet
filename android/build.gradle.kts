allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureProject = {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val compileSdkVersion = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    compileSdkVersion.invoke(android, 36)
                    println("ResQNet Build Config: Forced compileSdkVersion = 36 for subproject ${project.name}")
                } catch (e: Exception) {
                    try {
                        val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Integer::class.java)
                        setCompileSdk.invoke(android, 36)
                        println("ResQNet Build Config: Forced compileSdk = 36 for subproject ${project.name}")
                    } catch (ex: Exception) {
                        // ignore
                    }
                }
            }
        }
    }
    if (project.state.executed) {
        configureProject()
    } else {
        project.afterEvaluate {
            configureProject()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
