// 先頭に追加
import java.util.Properties
import java.io.FileInputStream

// android/ 配下の key.properties を読む
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    } else {
        logger.warn("key.properties not found at: ${keystorePropertiesFile.path}")
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter は Android/Kotlin の後に
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "io.github.yutotaniguchi.japanesehistoryapp"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "io.github.yutotaniguchi.japanesehistoryapp"
        minSdk = 23
        targetSdk = 35
        // pubspec.yaml の version をそのまま使う
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ← ここが肝：key.properties の値で release 署名
    signingConfigs {
        create("release") {
            val storeFilePath = (keystoreProperties["storeFile"] as String?)
            if (!storeFilePath.isNullOrBlank()) {
                storeFile = file(storeFilePath)
            }
            storePassword = (keystoreProperties["storePassword"] ?: error("storePassword missing")).toString()
            keyAlias      = (keystoreProperties["keyAlias"]      ?: error("keyAlias missing")).toString()
            keyPassword   = (keystoreProperties["keyPassword"]   ?: error("keyPassword missing")).toString()
            // storeType は通常不要（自動判定）。どうしても必要なときだけ指定。
            // storeType = "PKCS12" // 例
        }
    }

    // Flutter/AGP の安定設定：まずは 17 を推奨（不具合があれば 11→17→21 の順で）
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildTypes {
        release {
            // ★ debug 署名のままにしない！
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        // debug はデフォルトのままで OK
    }
}

kotlin {
    jvmToolchain(17)
}

flutter {
    source = "../.."
}
