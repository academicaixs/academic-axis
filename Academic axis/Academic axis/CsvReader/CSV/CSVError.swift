 
/// No overview available.
public enum CSVError: Error {

    /// No overview available.
    case cannotOpenFile
    /// No overview available.
    case cannotReadFile
    /// No overview available.
    case cannotWriteStream
    /// No overview available.
    case streamErrorHasOccurred(error: Error)
    /// No overview available.
    case unicodeDecoding
    /// No overview available.
    case cannotReadHeaderRow
    /// No overview available.
    case stringEncodingMismatch
    /// No overview available.
    case stringEndianMismatch

}
