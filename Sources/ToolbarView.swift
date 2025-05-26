import Adwaita

struct ToolbarView: View {

    @State private var about = false
    var app: AdwaitaApp
    var window: AdwaitaWindow

    var view: Body {
        HeaderBar.end {
            Menu(icon: .default(icon: .openMenu)) {
                MenuButton("New Window", window: false) {
                    app.addWindow("main")
                }
                .keyboardShortcut("n".ctrl())
                MenuButton("Close Window") {
                    window.close()
                }
                .keyboardShortcut("w".ctrl())
                MenuSection {
                    MenuButton("About", window: false) {
                        about = true
                    }
                }
            }
            .primary()
            .tooltip("Main Menu")
            .aboutDialog(
                visible: $about,
                app: "Quizzy",
                developer: "mohfy",
                version: "0.9.0",
                icon: .custom(name: "com.mohfy.quizzy"),
                website: .init(string: "https://github.com/mohfy/quizzy")!,
                issues: .init(string: "https://github.com/mohfy/quizzy/issues")!
            )
        }
    }

}
