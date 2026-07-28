import com.intellij.ide.FileSelectInContext
import com.intellij.ide.SelectInManager
import com.intellij.openapi.fileEditor.FileEditorManager
import liveplugin.registerAction

registerAction(id = "SelectInCommitView") { event ->
    val project = event.project ?: return@registerAction
    val file = FileEditorManager.getInstance(project)
        .selectedFiles.firstOrNull() ?: return@registerAction
    val target = SelectInManager.getInstance(project)
        .targetList.find { it.toString().contains("Commit") }
    target?.selectIn(FileSelectInContext(project, file), true)
}

registerAction(id = "SelectInStructureView") { event ->
    val project = event.project ?: return@registerAction
    val file = FileEditorManager.getInstance(project)
        .selectedFiles.firstOrNull() ?: return@registerAction
    val target = SelectInManager.getInstance(project)
        .targetList.find { it.toString().contains("File Structure") }
    target?.selectIn(FileSelectInContext(project, file), true)
}
