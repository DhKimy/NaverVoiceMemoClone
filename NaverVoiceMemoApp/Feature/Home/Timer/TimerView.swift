//
//  TimerView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/13/24.
//

import SwiftUI

struct TimerView: View {

    @StateObject var timerViewModel = TimerViewModel()

    var body: some View {
        if timerViewModel.isDisplaySetTimeView {
            // 타이머 설정 뷰
            SetTimerView(timerViewModel: timerViewModel)
        } else {
            // 타이머 작동 뷰
            TimerOperationView(timerViewModel: timerViewModel)
        }
    }
}

// MARK: - 타이머 설정 뷰
private struct SetTimerView: View {

    @ObservedObject private var timerViewModel: TimerViewModel

    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }

    fileprivate var body: some View {
        VStack {
            TitleView()

            Spacer()
                .frame(height: 50)

            TimePickerView(timerViewModel: timerViewModel)

            Spacer()
                .frame(height: 30)

            TimerCreateButtonView(timerViewModel: timerViewModel)

            Spacer()
        }
    }
}

private struct TitleView: View {

    fileprivate var body: some View {
        HStack {
            Text("타이머")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.custoBlack)

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
}

private struct TimePickerView: View {

    @ObservedObject private var timerViewModel: TimerViewModel

    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }

    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.custogray2)
                .frame(height: 1)

            HStack {
                Picker("Hour", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)시")
                    }
                }

                Picker("Minute", selection: $timerViewModel.time.minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)분")
                    }
                }

                Picker("Second", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)초")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)

            Rectangle()
                .fill(Color.custogray2)
                .frame(height: 1)
        }
    }
}

// MARK: - 타이머 생성 버튼 뷰
private struct TimerCreateButtonView: View {

    @ObservedObject private var timerViewModel: TimerViewModel

    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }

    fileprivate var body: some View {
        Button(action: {
            timerViewModel.settingButtonTapped()
        }) {
            Text("설정하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.custoGreen)
        }
    }
}

// MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {

    @ObservedObject private var timerViewModel: TimerViewModel

    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }

    fileprivate var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text(timerViewModel.timeRemaining.formattedTimeString)
                        .font(.system(size: 28))
                        .foregroundColor(.custoBlack)
                        .monospaced()

                    HStack(alignment: .bottom) {
                        Image(systemName: "bell.fill")

                        Text(timerViewModel.time.convertedSeconds.formattedSettingTime)
                            .font(.system(size: 16))
                            .foregroundColor(.custoBlack)
                            .padding(.top, 10)
                    }
                }

                Circle()
                    .stroke(Color.custoOrange, lineWidth: 6)
                    .frame(width: 350)
            }

            Spacer()
                .frame(height: 10)

            HStack {
                Button(action: {
                    timerViewModel.cancelButtonTapped()
                }) {
                    Text("취소")
                        .font(.system(size: 16))
                        .foregroundColor(.custoBlack)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 22)
                        .background(
                            Circle()
                                .fill(Color.custogray2.opacity(0.3))
                        )
                }

                Spacer()

                Button(action: {
                    timerViewModel.pauseOrRestartButtonTapped()
                }) {
                    Text(timerViewModel.isPaused ? "계속진행" : "일시정지")
                        .font(.system(size: 14))
                        .foregroundColor(.custoBlack)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 7)
                        .background(
                            Circle()
                                .fill(Color.custoGreen.opacity(0.3))
                        )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TimerView()
}
