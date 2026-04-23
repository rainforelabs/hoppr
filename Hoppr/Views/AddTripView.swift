//
//  AddTripView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import SwiftUI
import SwiftUIIntrospect

struct AddTripView: View {
  @Environment(TripModel.self) private var tripModel
  @Environment(\.dismiss) private var dismiss

  @State private var destination: String = ""
  @State private var duration: String = ""

  @State private var isFirstResponderSet = false
  @State private var uiTextField1: UITextField?
  @State private var uiTextField2: UITextField?

  var body: some View {
    @Bindable var model = tripModel

    ScrollView {
      VStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 4) {
          Text("Destination")
            .font(.callout)
            .foregroundStyle(.secondary)
          TextField(
            "Destination",
            text: $model.destination,
            prompt: Text("Where to hop next?")
              .foregroundStyle(Color(.tertiarySystemFill))
          )
          .font(.title2)
          .fontWeight(.bold)
          .keyboardType(.alphabet)
          .textInputAutocapitalization(.sentences)
          .introspect(.textField, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { tf in
            DispatchQueue.main.async {
              self.uiTextField1 = tf
              if self.isFirstResponderSet == false {
                tf.becomeFirstResponder()
                self.isFirstResponderSet = true
              }
            }
          }
          .submitLabel(.next)
          .onSubmit {
            uiTextField2?.becomeFirstResponder()
          }
        }
        VStack(alignment: .leading, spacing: 4) {
          Text("Duration")
            .font(.callout)
            .foregroundStyle(.secondary)
          TextField(
            "Duration",
            text: $model.duration,
            prompt: Text("How many days?")
              .foregroundStyle(Color(.tertiarySystemFill))
          )
          .font(.title2)
          .fontWeight(.bold)
          .keyboardType(.numberPad)
          .introspect(.textField, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { tf in
            DispatchQueue.main.async {
              self.uiTextField2 = tf
            }
          }
          .submitLabel(.done)
          .onSubmit {
            uiTextField2?.resignFirstResponder()
          }
        }

        PreferencesPickerView<Preferences.TravelStyle>(
          title: "What kind of trip are you in the mood for?",
          label: \.label,
          selection: $model.preferences.style
        )
        PreferencesPickerView<Preferences.Budget>(
          title: "What’s your budget range?",
          label: \.label,
          selection: $model.preferences.budget
        )
        PreferencesPickerView<Preferences.TravelGroup>(
          title: "Who are you traveling with?",
          label: \.label,
          selection: $model.preferences.group
        )
        PreferencesPickerView<Preferences.Pace>(
          title: "What pace feels right?",
          label: \.label,
          selection: $model.preferences.pace
        )
      }
      .padding(20)
    }
    .scrollIndicators(.hidden)
    .contentShape(Rectangle())
    .safeAreaBar(edge: .top) {
      HStack {
        Text("New Trip")
          .font(.title)
          .fontWeight(.semibold)
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
            .frame(width: 44, height: 44)
            .glassEffect(.regular.interactive())
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
    }
    .safeAreaBar(edge: .bottom) {
      generateButton
    }
    .onAppear {
      tripModel.invalidateInput()
    }
    .onTapGesture {
      uiTextField1?.resignFirstResponder()
      uiTextField2?.resignFirstResponder()
    }
  }

  private var generateButton: some View {
    Button {
      tripModel.generateTrip()
      UIImpactFeedbackGenerator(style: .light).impactOccurred()
      dismiss()
    } label: {
      Text("Generate Itinerary")
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background {
          Capsule()
            .fill(
              LinearGradient(
                colors: [.appAsh, .appCharcoal],
                startPoint: .top,
                endPoint: .bottom
              )
            )
        }
        .glassEffect(.regular.interactive())
    }
    .disabled(!tripModel.isValidInput)
    .buttonStyle(.plain)
    .padding(20)
  }
}

private struct PreferencesPickerView<T: CaseIterable & Hashable>: View {
  let title: String
  let label: (T) -> String
  @Binding var selection: T

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.callout)
        .foregroundStyle(.secondary)
      FlowLayout {
        ForEach(Array(T.allCases), id: \.self) { item in
          let selected = selection == item

          Button {
            withAnimation(.spring(duration: 0.3)) { selection = item }
          } label: {
            Text(label(item))
              .font(.subheadline)
              .fontWeight(selected ? .medium : .regular)
              .foregroundStyle(selected ? Color.white : Color(.label))
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background {
                Capsule()
                  .fill(Color(selected ? .appBlue : .quaternarySystemFill))
              }
          }
          .buttonStyle(BouncyHapticButtonStyle())
        }
      }
    }
  }
}

#Preview {
  ZStack {}
    .sheet(isPresented: Binding.constant(true)) {
      AddTripView()
        .environment(TripModel())
        .presentationBackground(Color(.surface))
        .interactiveDismissDisabled()
        .fontDesign(.rounded)
    }
}
