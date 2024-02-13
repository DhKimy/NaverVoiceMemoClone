//
//  VoiceRecoderView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import SwiftUI

struct VoiceRecoderView: View {

    @StateObject private var voiceRecorderViewModel = VoiceRecoderViewModel()
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
        ZStack {
            VStack {
                // 타이틀 뷰
                TitleView()

                // 안내뷰 || 보이스 레코더 리스트 뷰
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    AnnounceMentView()
                } else {
                    VoiceRecordListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }

                // 녹음버튼 뷰
                RecordButtonView(voiceRecorderViewModel: voiceRecorderViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
            }
        }
        .alert(
            "선택된 음성 메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) { }
        }
        .alert(
            voiceRecorderViewModel.alertMessage,
            isPresented: $voiceRecorderViewModel.isDisplayAlert
        ) {
            Button("확인", role: .cancel) { }
        }
        .onChange(of: voiceRecorderViewModel.recordedFiles) { record in
            homeViewModel.setVoiceRecorderCount(record.count)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {

    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.custoBlack)

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 안내뷰
private struct AnnounceMentView: View {

    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.custoCoolGray)
                .frame(height: 1)

            Spacer()
                .frame(height: 100)

            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다.\n하단의 녹음 버튼을 눌러 음성메모를 시작해주세요")

            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.custogray2)
    }
}

// MARK: - 보이스 레코드 리스트 뷰
private struct VoiceRecordListView: View {

    @ObservedObject private var voiceRecorderViewModel: VoiceRecoderViewModel

    fileprivate init(voiceRecorderViewModel: VoiceRecoderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }

    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.custogray2)
                    .frame(height: 1)

                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                    // 음성 메모 셀 뷰 호출
                    VoiceRecorderListCellView(
                        voiceRecorderViewModel: voiceRecorderViewModel,
                        recordedFile: recordedFile
                    )
                }
            }
        }
    }
}

// MARK: - 음성 메모 셀 뷰
private struct VoiceRecorderListCellView: View {

    @ObservedObject private var voiceRecorderViewModel: VoiceRecoderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecordedFile == recordedFile && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }

    fileprivate init(
        voiceRecorderViewModel: VoiceRecoderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }

    fileprivate var body: some View {
        VStack {
            Button(action: {
                voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
            }) {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.custoBlack)

                        Spacer()
                    }
                }

                Spacer()
                    .frame(height: 5)

                HStack {
                    if let creationDate = creationDate {
                        Text(creationDate.formattedVoiceRecorderTime)
                            .font(.system(size: 14))
                            .foregroundColor(.custoIconGray)
                    }

                    Spacer()

                    if voiceRecorderViewModel.selectedRecordedFile != recordedFile,
                       let duration = duration {
                        Text(duration.formattedTimeInterval)
                            .font(.system(size: 14))
                            .foregroundStyle(.customIconGray)
                    }
                }
            }
            .padding(.horizontal, 20)

            if voiceRecorderViewModel.selectedRecordedFile == recordedFile {
                VStack {
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)

                    Spacer()
                        .frame(height: 5)

                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.custoIconGray)

                        Spacer()

                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.custoIconGray)
                        }
                    }

                    Spacer()
                        .frame(height: 10)

                    HStack {
                        Spacer()

                        Button(action: {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        }) {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundColor(.custoBlack)
                        }

                        Spacer()
                            .frame(width: 10)

                        Button(action: {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        }) {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundColor(.custoBlack)
                        }

                        Spacer()

                        Button(action: {
                            voiceRecorderViewModel.removeButtonTapped()
                        }) {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.custoBlack)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Rectangle()
                .fill(Color.custogray2)
                .frame(height: 1)
        }
    }
}

// MARK: - 프로그래스 바
private struct ProgressBar: View {

    private var progress: Float

    fileprivate init(progress: Float) {
        self.progress = progress
    }

    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.custogray2)

                Rectangle()
                    .fill(Color.custoGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음버튼 뷰
private struct RecordButtonView: View {

    @ObservedObject private var voiceRecorderViewModel: VoiceRecoderViewModel

    fileprivate init(voiceRecorderViewModel: VoiceRecoderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }

    fileprivate var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    voiceRecorderViewModel.recordButtonTapped()
                }) {
                    if voiceRecorderViewModel.isRecording {
                        Image("mic_recording")
                    } else {
                        Image("mic")
                    }
                }
            }
        }
    }
}

#Preview {
    VoiceRecoderView()
}
