//
//  Fetcher.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case parameter(value: String)
    case responseError(error: Error, url: String?, statusCode: Int?)
    case response(url: String?, statusCode: Int?)
    case parseError(error: Error, head: String?, tail: String?)
    case invalidFormat(json: Any)
    case cancel
}

class Fetcher<T> where T: DomainObject {
    var session = URLSession.shared
    let baseAddress: URL
    var isFetched: Bool = false
    var isFetching: Bool = false

    init(addressURL: URL) {
        baseAddress = addressURL
    }

    convenience init?(address: String) throws {
        guard let url = URL(string: address) else {
            throw FetchError.parameter(value: address)
        }
        self.init(addressURL: url)
    }

    var domainObjects: [T] = [T]()
    var currentJob: Job<T>? {
        didSet {
            oldValue?.task.cancel()
            oldValue?.handler([], .cancel)
        }
    }
}

class Job<T> where T: DomainObject {
    var task: URLSessionDataTask
    var handler: ([T], FetchError?) -> Void

    init(task: URLSessionDataTask, handler: @escaping ([T], FetchError?) -> Void) {
        self.task = task
        self.handler = handler
    }
}

extension Fetcher {
    @discardableResult
    func fetch(_ complitionHandler: @escaping ([T], FetchError?) -> Void = { _,_ in }) -> Job<T> {
        isFetched = false
        isFetching = false

        let completionHandler = { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                self?.currentJob?.handler([T](),
                                    FetchError.responseError(error: error,
                                                             url: response?.url?.absoluteString,
                                                             statusCode: (response as? HTTPURLResponse)?.statusCode))
            }
            guard let data = data?.dropLast() else {
                self?.currentJob?.handler([T](),
                                          FetchError.response(url: response?.url?.absoluteString,
                                                                   statusCode: (response as? HTTPURLResponse)?.statusCode))
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data,
                                                                  options: [])
                guard let json = jsonObject as? [[Any]] else {
                    self?.currentJob?.handler([T](),
                                              FetchError.invalidFormat(json: jsonObject))
                    return
                }
                let domainObjects = try json.compactMap(T.init)
                self?.currentJob?.handler(domainObjects, nil)
                self?.domainObjects = domainObjects
            } catch {
                let head = data.subdata(in: data.startIndex..<data.startIndex.advanced(by: 100))
                let tail = data.subdata(in: data.endIndex.advanced(by: -100)..<data.endIndex)
                self?.currentJob?.handler([T](),
                                          FetchError.parseError(error: error,
                                                                head: String(data: head, encoding: String.Encoding.utf8),
                                                                tail: String(data: tail, encoding: String.Encoding.utf8)))
            }
        }

        let request = URLRequest(url: baseAddress)
        let job = Job(task: session.dataTask(with: request, completionHandler: completionHandler), handler: complitionHandler)
        currentJob = job
        isFetching = true
        job.task.resume()
        return job
    }
}
