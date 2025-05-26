import Adwaita

struct ToolbarView: View {

    @State private var about = false
    var app: AdwaitaApp
    var window: AdwaitaWindow

    var view: Body {
        HeaderBar.end {
            Menu(icon: .default(icon: .openMenu)) {
                MenuButton(Loc.newWindow, window: false) {
                    app.addWindow("main")
                }
                .keyboardShortcut("n".ctrl())
                MenuButton(Loc.closeWindow) {
                    window.close()
                }
                .keyboardShortcut("w".ctrl())
                MenuSection {
                    MenuButton(Loc.about, window: false) {
                        about = true
                    }
                }
            }
            .primary()
            .tooltip(Loc.mainMenu)
            .aboutDialog(
                visible: $about,
                app: "Quizzy",
                developer: "david-swift",
                version: "dev",
                icon: .custom(name: "com.mohfy.quizzy"),
                website: .init(string: "https://git.aparoksha.dev/aparoksha/adwaita-template")!,
                issues: .init(string: "https://git.aparoksha.dev/aparoksha/adwaita-template/issues")!
            )
        }
    }

}
