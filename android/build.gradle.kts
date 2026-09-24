buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven(url = "https://developer.huawei.com/repo/")
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
    // Workaround for huawei_health plugin bug where proguard-rules.pro is missing from the pub cache
    if (name == "huawei_health") {
        val proguardFile = file("${projectDir}/proguard-rules.pro")
        if (!proguardFile.exists()) {
            try {
                proguardFile.parentFile.mkdirs()
                proguardFile.createNewFile()
            } catch (e: Exception) {
                println("Error creating proguard-rules.pro for huawei_health: $e")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
