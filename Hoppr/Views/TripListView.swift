//
//  TripListView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import SwiftUI

struct TripListView: View {
  let trips: [Trip]
  let onSelect: (Trip) -> Void

  @State private var isSheetPresented = false

  var body: some View {
    Group {
      if trips.isEmpty {
        VStack {
          Spacer()
          Image(.coconutTree)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .padding(.bottom, 8)
          Text("Your trips will appear here,")
          Text("add your first one.")
          Spacer()
        }
        .font(.callout)
        .foregroundStyle(.secondary)
      } else {
        ScrollView {
          VStack {
            ForEach(trips, id: \.id) { trip in
              TripCard(trip: trip) { onSelect(trip) }
            }
          }
          .padding(20)
        }
        .scrollIndicators(.hidden)
      }
    }
    .safeAreaBar(edge: .top) {
      HStack {
        Image(.appBrand)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 32)
        Spacer()
        Button {
          isSheetPresented = true
        } label: {
          Image(systemName: "plus")
            .frame(width: 44, height: 44)
            .foregroundStyle(.white)
            .background {
              Circle()
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
        .buttonStyle(.plain)
        .contentShape(Rectangle())
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
    }
    .sheet(isPresented: $isSheetPresented) {
      AddTripView()
        .presentationBackground(Color(.surface))
    }
  }
}

private struct TripCard: View {
  let trip: Trip
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      VStack(alignment: .leading) {
        Text("\(trip.destination) trip")
          .font(.title2)
          .fontWeight(.semibold)
        HStack(spacing: 2) {
          Text("\(trip.duration) days itinerary,")
          Text("\(trip.activityCount) activities")
        }
        .foregroundStyle(.secondary)
        FlowLayout {
          ForEach(trip.preferences.labels, id: \.self) { label in
            Text(label)
              .font(.subheadline)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background {
                Capsule()
                  .fill(Color(.appAsh).opacity(0.08))
              }
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.fieldFills))
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ZStack {
    Color(.appGrey)
      .ignoresSafeArea()
  }
  .fontDesign(.rounded)
  .sheet(isPresented: Binding.constant(true)) {
    TripListView(trips: [.preview]) { _ in }
      .environment(TripModel())
      .presentationDetents([.fraction(0.4), .fraction(0.7)])
      .presentationBackground(Color(.surface))
      .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.7)))
      .interactiveDismissDisabled()
  }
}
