import com.google.gson.Gson
import java.util.LinkedList

initscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        // https://mvnrepository.com/artifact/com.google.code.gson/gson
        classpath("com.google.code.gson:gson:2.10.1")
    }
}

data class TaskData(val name: String, val group: String?, val description: String?)

data class TaskDump(
    var projectName: String,
    var tasks: Map<String, MutableList<TaskData>> = emptyMap(),
    var subprojects: List<TaskDump> = emptyList()
)

fun mapProjectTasks(project: Project): TaskDump {
    val dump = TaskDump(project.name)
    val taskDump = HashMap<String, MutableList<TaskData>>()

    project.tasks.map {
        TaskData(
            it.name,
            it.group,
            it.description
        )
    }.forEach {
        if (it.group == null) {
            if (!taskDump.containsKey("other")) {
                taskDump["other"] = LinkedList<TaskData>()
            }
            taskDump["other"]!!.add(it)
        } else {
            if (!taskDump.containsKey(it.group)) {
                taskDump[it.group] = LinkedList<TaskData>()
            }
            taskDump[it.group]!!.add(it)
        }
    }

    dump.tasks = taskDump
    dump.subprojects = project.subprojects.map {
        mapProjectTasks(it)
    }
    return dump
}
allprojects {
    if(project.rootProject == project) {
        tasks.register("godleDumpTasks") {
            doLast {
                //make a dump of all registered classes, so Godot can pick them up properly.
                val taskDump = mapProjectTasks(project)
                val dump = Gson().toJson(taskDump)
                println(dump)
            }
        }
    }

}