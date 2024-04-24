//
//  Api.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation

class Api {
    static func getInfo(url: String = Domain.info, completion: @escaping (StationsModel) -> ()) {
        guard let url: URL = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error in: getInfo")
                    return
            }
            do {
                let status = try JSONDecoder().decode(StationsModel.self, from: data)
                completion(status)
            } catch {
                print("Error: Couldn't decode data in: getInfo")
            }
        }.resume()
    }
    
    static func getStatus(url: String = Domain.status, completion: @escaping (StationsModel) -> ()) {
        guard let url: URL = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error in: getStatus")
                    return
            }
            do {
                let info = try JSONDecoder().decode(StationsModel.self, from: data)
                completion(info)
            } catch {
                print("Error: Couldn't decode data in: getStatus")
            }
        }.resume()
    }
    
    static func getStatusAsync() async throws -> StationsModel {
        guard let url = URL(string: Domain.status) else {
            throw "Invalid URL"
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(StationsModel.self, from: data)
        return result
    }
    
    static func getInfoAsync() async throws -> StationsModel {
        guard let url = URL(string: Domain.info) else {
            throw "Invalid URL"
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(StationsModel.self, from: data)
        return result
    }
}

extension String: Error {}
