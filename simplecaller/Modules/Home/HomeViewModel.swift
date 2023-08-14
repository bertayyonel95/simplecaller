//
//  HomeViewModel.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation
import AVFoundation
import AgoraRtcKit

enum CallStateVM: String {
    case onCall
    case standby
}

// MARK: - HomeViewModelInput
protocol HomeViewModelInput {
    // MARK: Properties
    var output: HomeViewModelOutput? { get set }
    var callState: CallStateVM { get set }
    func initializeAgoraEngine()
    func cleanUp()
    func requestMicAccess()
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func startCall(with external_ID: String)
    func checkAndAddExternalID(with externalID: String)
    func getContacts()
}

// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    func home(title: String, text: String)
    func home(state: CallStateVM)
    func home(_ userExistsWith: String)
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
    func home(isRegistered: Bool)
}

final class HomeViewModel: NSObject, HomeViewModelInput {
    var agoraEngine: AgoraRtcEngineKit!
    var userRole: AgoraClientRole = .broadcaster
    let appID = Constants.appID
    
    private let homeRouter: HomeRouting
    private let externalIDAPI: ExternalIDFetchable
    private let postVoIPAPI: PostVoIPFetchable
    private let tokenAPI: TokenFetchable
    private let agoraManager = AgoraManager()
    private let callManager = CallManager()
    private var sections: [Section] = []
    private var contactsList: [String] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    private var token: String = .empty
    var callState: CallStateVM = .standby
    
    
    weak var output: HomeViewModelOutput?
    
    init(homeRouter: HomeRouting, externalIDAPI: ExternalIDFetchable, tokenAPI: TokenFetchable, postVoIP: PostVoIPFetchable) {
        self.homeRouter = homeRouter
        self.externalIDAPI = externalIDAPI
        self.tokenAPI = tokenAPI
        self.postVoIPAPI = postVoIP
        super.init()

    }
    
    func getToken() {
        let requestModel = TokenRequestModel(with: "testRoom", and: "testUserID")
        tokenAPI.retrieveToken(request: requestModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print(success.rtcToken)
                token = success.rtcToken
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUser(with externalID: String) {
        let requestModel = ExternalIDRequestModel(with: externalID)
        externalIDAPI.retrieveByExternalID(request: requestModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                output?.home(success.identity.external_id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func generateCellData() {
        contactsList.forEach { contact in
            let cellViewModel = generateViewModel(with: contact)
            cells.append(cellViewModel)
        }
        cells.forEach { item in
            let section = Section(userCellViewModel: item)
            if !sections.contains(section) { sections.append(section) }
        }
        output?.home(self, sectionDidLoad: sections)
    }
    
    func generateViewModel(with externalID: String) -> HomeCollectionViewCellViewModel {
        HomeCollectionViewCellViewModel(external_id: externalID)
    }
    
    func getSections() -> [Section] {
        sections
    }
    
    func updateSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    func checkAndAddExternalID(with externalID: String) {
        let requestModel = ExternalIDRequestModel(with: externalID)
        externalIDAPI.retrieveByExternalID(request: requestModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                do {
                    contactsList.append(success.identity.external_id)
                    try UserDefaultsManager.shared.setObject(contactsList, forKey: "contacts")
                    generateCellData()
                }
                catch {
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getContacts() {
        do {
            let contactList = try UserDefaultsManager.shared.getObject(forKey: "contacts", castTo: [String].self)
            self.contactsList = contactList
            self.generateCellData()
        } catch {
        }
    }
    
    func startCall(with external_ID: String) {
        var senderID: String = .empty
        do {
            senderID = try UserDefaultsManager.shared.getObject(forKey: "userID", castTo: String.self)
        } catch {
            
        }
        let channelID = UUID().uuidString
        let post = PostModel(senderID: senderID, receiverID: external_ID as String, channelID: channelID)
        post.generatePost()
        Task {
            await agoraManager.joinChannel(with: channelID)
        }
        callManager.startCall(handle: external_ID, videoEnabled: false)
    }
    
    func cleanUp() {
        agoraManager.cleanUp()
    }
    
    func requestMicAccess() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                // User granted microphone access
                print("Microphone access granted")
            } else {
                // User denied microphone access or didn't respond
                print("Microphone access denied")
            }
        }
    }

}

// MARK: - Voice Channel
extension HomeViewModel: AgoraRtcEngineDelegate {
    
    func checkForPermissions() async -> Bool {
        let hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = appID
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        
    }
}
