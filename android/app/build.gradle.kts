plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties().apply {
    load(FileInputStream(rootProject.file("key.properties")))
}

android {
    namespace = "io.github.yutotaniguchi.japanesehistoryapp"
    compileSdk = 35
    ndkVersion = "28.2.13676358"
    packaging {
        jniLibs {
            // 16KB page-size 対応のための必須設定（AGP 8.1+）
            useLegacyPackaging = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "io.github.yutotaniguchi.japanesehistoryapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        manifestPlaceholders["supportsLargeHeaps"] = "true"

        
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters += listOf("arm64-v8a")
        

        }
    
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isShrinkResources = true
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    // ★★ ここから追加 ★★
    flavorDimensions += "env"

    productFlavors {
    create("prod") {
        dimension = "env"
        applicationIdSuffix = ""
    }
    create("dev") {
        dimension = "env"
        applicationIdSuffix = ""
    }
}

}

flutter {
    source = "../.."
}