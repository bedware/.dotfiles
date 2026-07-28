import com.intellij.openapi.fileEditor.OpenFileDescriptor
import com.intellij.openapi.vfs.LocalFileSystem
import liveplugin.registerAction
import liveplugin.show
import java.io.File

registerAction(id = "OpenIdeaVimRc") { event ->
    val project = event.project ?: return@registerAction
    val home = System.getProperty("user.home")
    val xdg = System.getenv("XDG_CONFIG_HOME")?.takeIf { it.isNotBlank() }
        ?: "$home/.config"

    // Порядок поиска как у самого IdeaVim: XDG -> ~/.ideavimrc -> ~/.vim/ideavimrc
    val candidates = listOf(
        "$xdg/ideavim/ideavimrc",
        "$home/.ideavimrc",
        "$home/.vim/ideavimrc",
    )

    val path = candidates.firstOrNull { File(it).isFile }
        ?: run { show("No .ideavimrc found in:\n${candidates.joinToString("\n")}"); return@registerAction }

    val vFile = LocalFileSystem.getInstance().refreshAndFindFileByPath(path)
        ?: run { show("Can't resolve VirtualFile: $path"); return@registerAction }

    OpenFileDescriptor(project, vFile).navigate(true)
}

show("OpenIdeaVimRc registered")