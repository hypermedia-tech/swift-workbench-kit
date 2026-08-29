import Foundation

/// What KIND of thing a row is, as an SF Symbol name. Two strings in, one out — no file access, no
/// Domain type, no view.
///
/// It lives in the kit because a navigator row, a jump-bar component and a menu entry must not
/// disagree about what a `.pdf` looks like, and because the planned git view will want the same
/// table. It arrives here from `FileTreeView`, where it was private inside a private struct and
/// therefore unusable by the two surfaces that needed it most.
///
/// Tint is deliberately NOT here: the navigator tints folders blue and files secondary, while a
/// bar draws everything secondary. Same glyph, different treatment, and the treatment belongs to
/// the surface.
public enum FileKindSymbol {
    public static func name(forPathExtension pathExtension: String, isDirectory: Bool) -> String {
        if isDirectory { return "folder.fill" }
        return switch pathExtension.lowercased() {
        case "swift":                              "swift"
        case "txt", "md", "markdown":              "doc.text"
        case "yaml", "yml", "json":                "curlybraces"
        case "m4a", "mp3", "wav", "aiff":          "waveform"
        case "png", "jpg", "jpeg", "heic", "gif":  "photo"
        case "pdf":                                "doc.richtext"
        default:                                   "doc"
        }
    }
}
