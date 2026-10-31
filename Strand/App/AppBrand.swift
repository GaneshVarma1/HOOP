/// The fork's iPhone display name. Shared screens keep the original name on macOS.
enum AppBrand {
    #if os(iOS)
    static let name = "HOOP"
    #else
    static let name = "HOOP"
    #endif
}
