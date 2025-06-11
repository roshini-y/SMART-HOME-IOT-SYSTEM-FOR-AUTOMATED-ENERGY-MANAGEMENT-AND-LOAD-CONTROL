allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // Google services plugin (ensure the correct version)
    id("com.google.gms.google-services") version "4.3.15" apply false
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

buildscript {
    dependencies {
        // Same version for consistency
        classpath("com.google.gms:google-services:4.3.15")
    }
}
