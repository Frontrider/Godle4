import io.github.frontrider.godle.dsl.versioning.asGodot4Beta
import io.github.frontrider.godle.dsl.versioning.asGodot
import io.github.frontrider.godle.publish.dsl.AssetCategories
import io.github.frontrider.godle.publish.dsl.currentCommitHash
import godle.license.MIT


plugins {
    id("io.github.frontrider.godle-publish") version "0.3.2"
    id("io.github.frontrider.godle") version "0.20.0"
}

repositories {
    mavenCentral()
}

godle {
    asGodot4Beta("16")
}


val godotUsername:String by project
val godotPassword:String by project

godlePublish{
    create("Godle4"){
        description = """
             Companion addon for the Godle Gradle plugin.
        """.trimIndent()
        supportLevel.set("community")
        downloadProvider.set("GitHub")
        category = AssetCategories.Tools
        godotVersion.set("4.0")
        vcsUrl.set("https://github.com/Frontrider/Godle-Godot-Addon")
        iconUrl.set("https://raw.githubusercontent.com/Frontrider/Godot-Scene-Browser/${currentCommitHash()}/icon.png")
        license = MIT()
        credentials{
            username = godotUsername
            password = godotPassword
        }
    }
}