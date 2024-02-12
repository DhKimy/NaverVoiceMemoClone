//
//  VoiceRecoderViewModel.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import AVFoundation

/**
 NSObject를 상속하는 이유
 AVAudioPlayerDelegate의 모든 메서드를 직접 구현하지 않기 위함.
 AVAudioPlayerDelegate가 NSObject의  런타임 매커니즘을 간접적으로 사용한다.
 */
class VoiceRecoderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isDisplayRemoveVoiceRecorderAlert: Bool
    @Published var isDisplayErrorAlert: Bool
    @Published var errorAlertMessage: String

    // 음성 메모 녹음 관련 프로퍼티
    @Published var isRecording: Bool
    var audioRecorder: AVAudioRecorder?

    // 음성 메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?

    // 음성 메모된 파일
    var recordedFiles: [URL]

    // 현재 선택된 음성메모 파일
    @Published var selectedRecordedFile: URL?

    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = []
    ) {
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayErrorAlert = isDisplayErrorAlert
        self.errorAlertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
    }
}

// MARK: - 뷰 관련 메서드
extension VoiceRecoderViewModel {

    func voiceRecordCellTapped(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            stopPlaying()
            selectedRecordedFile = recordedFile
        }
    }

    func removeButtonTapped() {
        setIsDisplayRemoveVoiceRecoderAlert(true)
    }

    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert("선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }

        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            stopPlaying()
            displayAlert("선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert("선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }

    private func setIsDisplayRemoveVoiceRecoderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }

    private func setErrorAlertMessage(_ message: String) {
        errorAlertMessage = message
    }

    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayErrorAlert = isDisplay
    }

    private func displayAlert(_ message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecoderViewModel {

    func recordButtonTapped() {
        selectedRecordedFile = nil

        if isPlaying {
            stopPlaying()
            startRecording()
        } else if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        let fileURL = getDocumentDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert("음성 메모 녹음 중 오류가 발생했습니다.")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        self.recordedFiles.append(self.audioRecorder!.url)
        self.isRecording = false
    }

    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

// MARK: - 음성 메모 재생 관련
extension VoiceRecoderViewModel {

    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                self.updateCurrentTime()
            }
        } catch {
            displayAlert("음성 메모 재생 중 오류가 발생했습니다.")
        }
    }

    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }

    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }

    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var createDate: Date?
        var duration: TimeInterval?

        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            createDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert("선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert("선택된 음성메모 파일의 재생시간을 불러올 수 없습니다.")
        }

        return (createDate, duration)
    }

    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }

    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
}
