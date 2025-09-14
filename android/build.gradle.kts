//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
//rootProject.layout.buildDirectory.value(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.value(newSubprojectBuildDir)
//}
//subprojects {
//    project.evaluationDependsOn(":app")
//}
//
//tasks.register<Delete>("clean") {
//    delete(rootProject.layout.buildDirectory)
//}
//
//plugins {
//    // ... other plugins
//
//    // Force Google services Gradle plugin to a single version
//    id("com.google.gms.google-services") version "4.4.3" apply false
//}
//
//buildscript {
//    dependencies {
//        // 👇 Force Gradle to drop any 4.3.15 pulled by transitive deps
//        classpath("com.google.gms:google-services:4.4.3")
//    }
//}
//
// ✅ Remove version here
plugins {
    // other plugins...
    id("com.google.gms.google-services") apply false
}

buildscript {
    dependencies {
        // ✅ Force the Google services plugin version everywhere
        classpath("com.google.gms:google-services:4.4.3")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
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
