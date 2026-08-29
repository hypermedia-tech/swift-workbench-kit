import Testing
@testable import WorkbenchKit

/// `FileKindSymbol` is a pure lookup table three surfaces now share (navigator row, jump-bar
/// component, menu entry). The suite guards the table itself: every mapped extension, the
/// case-insensitivity the surfaces rely on, the `doc` fallback, and the rule that a directory
/// wins over any extension it happens to carry.
@Suite("FileKindSymbol")
struct FileKindSymbolTests {

    @Test(arguments: [
        ("swift", "swift"),
        ("txt", "doc.text"), ("md", "doc.text"), ("markdown", "doc.text"),
        ("yaml", "curlybraces"), ("yml", "curlybraces"), ("json", "curlybraces"),
        ("m4a", "waveform"), ("mp3", "waveform"), ("wav", "waveform"), ("aiff", "waveform"),
        ("png", "photo"), ("jpg", "photo"), ("jpeg", "photo"), ("heic", "photo"), ("gif", "photo"),
        ("pdf", "doc.richtext"),
    ])
    func eachMappedExtensionReturnsItsGlyph(pathExtension: String, glyph: String) {
        #expect(FileKindSymbol.name(forPathExtension: pathExtension, isDirectory: false) == glyph)
    }

    @Test func lookupIsCaseInsensitive() {
        #expect(
            FileKindSymbol.name(forPathExtension: "PDF", isDirectory: false)
            == FileKindSymbol.name(forPathExtension: "pdf", isDirectory: false))
        #expect(FileKindSymbol.name(forPathExtension: "JSON", isDirectory: false) == "curlybraces")
    }

    @Test func anUnknownExtensionFallsBackToDoc() {
        #expect(FileKindSymbol.name(forPathExtension: "xyz", isDirectory: false) == "doc")
        #expect(FileKindSymbol.name(forPathExtension: "", isDirectory: false) == "doc")
    }

    /// A directory is a folder even when its name carries a mapped extension.
    @Test func directoryWinsOverAnyExtension() {
        #expect(FileKindSymbol.name(forPathExtension: "md", isDirectory: true) == "folder.fill")
        #expect(FileKindSymbol.name(forPathExtension: "", isDirectory: true) == "folder.fill")
    }
}
