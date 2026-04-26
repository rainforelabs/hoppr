//
//  TripListView.swift
//  Hoppr
//
//  Created by Aditya Rohman on 22/04/26.
//

import SwiftUI

struct TripListView: View {
  let trips: [Trip]
  let isLoading: Bool
  let onSelect: (Trip) -> Void

  @State private var isSheetPresented = false

  var body: some View {
    ZStack {
      if trips.isEmpty && !isLoading {
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
            if isLoading {
              ForEach(0..<3, id: \.self) { _ in
                TripRowSkeleton()
              }
            } else {
              ForEach(trips) { trip in
                TripCard(trip: trip) { onSelect(trip) }
              }
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
          .frame(height: 44)
        Spacer()
        Button {
          isSheetPresented = true
        } label: {
          Image(systemName: "plus")
            .foregroundStyle(.white)
            .frame(width: 44, height: 44)
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
            .contentShape(Rectangle())
        }
        .buttonStyle(BouncyHapticButtonStyle())
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
    let prefs = trip.preferences

    Button(action: onTap) {
      VStack(alignment: .leading) {
        Text("\(trip.destination) trip")
          .font(.title3)
          .fontWeight(.semibold)
        HStack(spacing: 2) {
          Text("\(trip.duration) days itinerary,")
          Text("\(trip.activityCount) activities")
        }
        .foregroundStyle(.secondary)
        FlowLayout(spacing: 6) {
          ForEach(Array(zip(prefs.icons, prefs.labels)), id: \.0) { icon, label in
            HStack(spacing: 4) {
              Image(systemName: icon)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
              Text(label)
                .font(.footnote)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
              Capsule()
                .fill(Color(.quaternarySystemFill))
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.fieldFills))
      }
    }
    .buttonStyle(BouncyHapticButtonStyle())
  }
}

struct TripRowSkeleton: View {
  @State private var shimmer = false

  var body: some View {
    HStack(spacing: 12) {
      RoundedRectangle(cornerRadius: 8)
        .frame(width: 48, height: 48)
      VStack(alignment: .leading, spacing: 6) {
        RoundedRectangle(cornerRadius: 16)
          .frame(width: 200, height: 16)
        RoundedRectangle(cornerRadius: 16)
          .frame(width: 150, height: 16)
      }
      Spacer()
    }
    .foregroundStyle(Color(.secondarySystemFill))
    .padding()
    .background {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(.quaternarySystemFill))
    }
    .opacity(shimmer ? 0.4 : 1)
    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: shimmer)
    .onAppear { shimmer = true }
  }
}

#Preview {
  ZStack {}
    .sheet(isPresented: Binding.constant(true)) {
      TripListView(trips: [.preview], isLoading: false) { _ in }
        .environment(TripModel())
        .presentationDetents([.fraction(0.37), .fraction(0.59)])
        .presentationBackground(Color(.surface))
        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.59)))
        .interactiveDismissDisabled()
        .fontDesign(.rounded)
    }
}
