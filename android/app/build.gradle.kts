plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.vndblite.dcj"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // For flutter_local_notifications package
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.vndblite.dcj"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
		multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            val storeFilePath = System.getenv("VNP_KEYSTORE_PATH")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
                storePassword = System.getenv("VNP_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("VNP_KEY_ALIAS")
                keyPassword = System.getenv("VNP_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {

            signingConfig = signingConfigs.getByName("release")
			
			isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
	implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")

    // For flutter_local_notifications package
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") 
}
