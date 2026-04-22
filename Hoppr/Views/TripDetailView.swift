//
//  TripDetailView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import SwiftUI

struct TripDetailView: View {
  let trip: Trip
  let onBack: () -> Void

  @State private var selectedDay: Int = 1

  var body: some View {
    VStack(alignment: .leading) {
      tripItinerary
    }
    .safeAreaBar(edge: .top) {
      tripDetails
    }

  }

  private var tripDetails: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 16) {
        Button(action: onBack) {
          Image(systemName: "chevron.left")
            .frame(width: 44, height: 44)
            .glassEffect(.regular.interactive())
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())

        Text("\(trip.destination) trip")
          .font(.title)
          .fontWeight(.semibold)
      }
      .padding(.horizontal, 20)

      ScrollView(.horizontal) {
        HStack(spacing: 8) {
          ForEach(1...trip.duration, id: \.self) { day in
            let selected = selectedDay == day

            Button {
              selectedDay = day
            } label: {
              Text("Day-\(day)")
                .fontWeight(selected ? .medium : .regular)
                .foregroundStyle(Color(selected ? .white : .secondary))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                  Capsule()
                    .fill(Color(selected ? .appBlue : .fieldFills))
                }
            }
            .buttonStyle(.plain)

          }
        }
        .padding(.horizontal, 20)
      }
      .scrollIndicators(.hidden)
    }
    .padding(.top, 20)
  }

  private var tripItinerary: some View {
    ScrollView {
      VStack {
        let day = trip.itinerary[selectedDay - 1]

        ForEach(Array(zip(day.slotLabels, day.activities)), id: \.0) { label, activity in
          let dayIcon =
            switch label.lowercased() {
            case "morning": "sunrise"
            case "afternoon": "sun.max"
            case "evening": "sunset"
            default: ""
            }

          VStack(alignment: .leading) {
            HStack {
              HStack(spacing: 4) {
                Image(systemName: dayIcon)
                Text(label)
              }
              .font(.subheadline)
              .foregroundStyle(Color(.appAsh))
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background {
                Capsule()
                  .fill(Color(Color(.appAsh).opacity(0.07)))
              }
              HStack(spacing: 4) {
                Text(activity.category.emoji)
                  .font(.footnote)
                Text(activity.category.label)
                  .font(.subheadline)
                  .foregroundStyle(activity.category.color)
              }
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background {
                Capsule()
                  .fill(activity.category.color.opacity(0.07))
              }
            }
            Text(activity.name)
              .font(.title3)
              .fontWeight(.medium)
              .padding(.bottom, 2)
            Text(activity.description)
              .foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          if label != day.slotLabels.last {
            Divider()
              .frame(height: 1)
              .overlay(Color(.appGrey))
              .padding(.vertical, 4)
          }
        }
      }
      .padding(20)
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  ZStack {
    Color(.appGrey)
      .ignoresSafeArea()
  }
  .fontDesign(.rounded)
  .sheet(isPresented: Binding.constant(true)) {
    TripDetailView(trip: .preview) {}
      .presentationDetents([.fraction(0.4), .fraction(0.7)])
      .presentationBackground(Color(.surface))
      .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.7)))
      .interactiveDismissDisabled()
  }
}
