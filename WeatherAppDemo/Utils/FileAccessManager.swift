//
//  FileAccessManager.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation
import Combine

public class FileAccessManager: NSObject {
    public static let shared = FileAccessManager()
    // Accessors
    private var documentsURL: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private override init() {
        // Singleton object
    }

    /// Read file from documents
    /// - Parameters:
    ///   - name: Filename without extension
    ///   - appendedPath: Should be defined if the walk exists between _root_ and file
    /// - Returns: Data object which contains the information in the file given
    public func readData(name: String, appendedPath: String?) -> Data? {
        var docURL = self.documentsURL
        if let appended = appendedPath {
            docURL.appendPathComponent(appended)
        }
        docURL.appendPathComponent(name)
        return FileManager.default.contents(atPath: docURL.path)
    }

    public func readJSON<T: Codable>(name: String, type: T.Type) -> T? {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: "json") {
            if let content = FileManager.default.contents(atPath: fileURL.relativePath) {
                return try? JSONDecoder().decode(T.self, from: content)
            }
        }
        return nil
    }

    /// Write **Codable** object to file with given name in documents
    /// - Parameters:
    ///   - name: File name
    ///   - appendedPath: Walk path
    ///   - obj: Given object as Codable
    /// - Throws: Encoding or FileIO error
    public func write<T>(name: String, appendedPath: String?, obj: T) throws where T: Codable {
        var docURL = self.documentsURL
        if let appended = appendedPath {
            docURL.appendPathComponent(appended)
        }
        docURL.appendPathComponent(name)
        if !FileManager.default.fileExists(atPath: docURL.relativePath) {
            FileManager.default.createFile(atPath: docURL.relativePath, contents: nil, attributes: nil)
        }
        let data = try JSONEncoder().encode(obj)
        try data.write(to: docURL, options: .atomicWrite)
    }

    /// just for .json
    /// - Parameters:
    ///   - name: filename
    ///   - obj: codable object
    /// - Throws: FileAccessErrors.writeFail
    public func write<T: Codable>(name: String, obj: T) throws {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: "json") {
            guard let stream = OutputStream(toFileAtPath: fileURL.path, append: false) else { return }
            stream.open(); defer { stream.close() }
            var errPtr: NSError?
            JSONSerialization.writeJSONObject(obj, to: stream, options: .fragmentsAllowed, error: &errPtr)
            if errPtr != nil {
                throw FileAccessErrors.writeFail
            }
        }
    }

    public func readPListInBundle(name: String) -> NSDictionary {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: "plist") {
            return NSDictionary(contentsOf: fileURL) ?? [:]
        }
        return [:]
    }

    public func isPListExist(_ name: String) -> Bool {
        return Bundle.main.url(forResource: name, withExtension: "plist") != nil
    }
}
