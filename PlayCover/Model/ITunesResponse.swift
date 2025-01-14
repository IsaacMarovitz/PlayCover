//
//  ITunesResponse.swift
//  PlayCover
//
//  Created by Isaac Marovitz on 23/08/2022.
//

import Foundation

struct ITunesResult: Codable {
    var isGameCenterEnabled: Bool
    var supportedDevices: [String]
    var features: [String]
    var advisories: [String]
    var screenshotUrls: [String]
    var ipadScreenshotUrls: [String]
    var appletvScreenshotUrls: [String]
    var artworkUrl60: String
    var artworkUrl512: String
    var artworkUrl100: String
    var artistViewUrl: String
    var kind: String
    var isVppDeviceBasedLicensingEnabled: Bool
    var currentVersionReleaseDate: String
    var releaseNotes: String
    var description: String
    var trackId: Int
    var trackName: String
    var bundleId: String
    var sellerName: String
    var genreIds: [String]
    var primaryGenreName: String
    var primaryGenreId: Int
    var currency: String
    var formattedPrice: String
    var contentAdvisoryRating: String
    var averageUserRatingForCurrentVersion: Float
    var userRatingCountForCurrentVersion: Int
    var trackViewUrl: String
    var trackContentRating: String
    var averageUserRating: Float
    var minimumOsVersion: String
    var trackCensoredName: String
    var languageCodesISO2A: [String]
    var fileSizeBytes: String
    var releaseDate: String
    var artistId: Int
    var artistName: String
    var genres: [String]
    var price: Float
    var version: String
    var wrapperType: String
    var userRatingCount: Int
}

struct ITunesResponse: Codable {
    var resultCount: Int
    var results: [ITunesResult]
}

func getITunesData(_ itunesLookup: String) async -> ITunesResponse? {
    guard NetworkVM.isConnectedToNetwork(), let url = URL(string: itunesLookup) else {
        return nil
    }

    return await withCheckedContinuation { continuation in
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            do {
                if error == nil, let data = data {
                    let decoder = JSONDecoder()
                    let jsonResult: ITunesResponse = try decoder.decode(ITunesResponse.self, from: data)
                    continuation.resume(returning: jsonResult.resultCount > 0 ? jsonResult : nil)
                    return
                }
            } catch {
                print("Error getting iTunes data from URL: \(itunesLookup): \(error)")
            }

            continuation.resume(returning: nil)
        }.resume()
    }
}
