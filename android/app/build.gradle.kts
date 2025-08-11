import java.util.Properties
import java.io.FileInputStream
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
// android/ 配下にある key.properties を読む（app から見て ../key.properties）
val keystorePropsFile = rootProject.file("key.properties")
val keystoreProps = Properties().apply {
    if (keystorePropsFile.exists()) {
        load(FileInputStream(keystorePropsFile))
    } else {
        logger.warn("key.properties not found at: ${keystorePropsFile.path}")
    }
}


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "io.github.yutotaniguchi.japanesehistoryapp"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId =  "io.github.yutotaniguchi.japanesehistoryapp"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("release_prod.keystore")   // android/app/release.keystore
            storePassword = "kokekiko2525"
            keyAlias = "upload"
            keyPassword = "kokekiko2525"
            storeType = "PKCS12"       
        }
    }
    compileOptions {
        // ★ Java を 21 に
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    jvmToolchain(21)
}

tasks.withType<KotlinCompile>().configureEach {
    kotlinOptions {
        jvmTarget = "21"
    }
}