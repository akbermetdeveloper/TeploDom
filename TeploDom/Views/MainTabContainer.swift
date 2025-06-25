//
//  MainTabContainer.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct MainTabContainer: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var iapViewModel: IAPViewModel
    
    
      @StateObject private var mainViewModel = MainViewModel()
      @StateObject private var metersViewModel = MetersViewModel()
      @StateObject private var consumptionViewModel = ConsumptionViewModel()
      @StateObject private var readingsViewModel = ReadingsViewModel()
      @StateObject private var settingsViewModel = SettingsViewModel()
    
    
    @State private var selectedTab: CustomTabBarView.Tab = .main
      @State private var sheetState: SheetState = .partial
    //  @State private var isKeyboardVisible = false
    //  @State private var showingCreatePlace = false
    //  @State private var hasCheckedPermissions = false
    //  @State private var showLocationCard = true
    //  @State private var showNotificationsCard = true
    //  @State private var showMotionCard = true
    
    
      @ObservedObject var subViewModel: SubViewModel
    //  @StateObject private var createViewModel: PlaceCreationViewModel
    //
    //
    //  private let placesService: PlacesServiceProtocol
    //
      let screenHeight = UIScreen.main.bounds.height
    //
    //
    //  init(subViewModel: SubViewModel) {
    //    self.subViewModel = subViewModel
    //
    //
    //    let userLocationService = UserLocationService()
    //    _locationViewModel = StateObject(wrappedValue:
    //                                      LocationViewModel(userService: userLocationService))
    //
    //
    //    self.placesService = PlacesService()
    //    _createViewModel = StateObject(wrappedValue:
    //                                    PlaceCreationViewModel(placesService: PlacesService()))
    //  }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            BackgroundView()
            
            MainView(
              //viewModel: mainViewModel,
              selectedTab: $selectedTab, subViewModel: subViewModel
            )
            
            .ignoresSafeArea()

            
            VStack {
              switch selectedTab {
              case .main:
                mainView
              case .meters:
                metersView
              case .consumptions:
                consumptionsView
              case .readings:
                  readingsView
              case . settings:
                  settingsView
              }
            }
            .ignoresSafeArea()
            
            CustomTabBarView(selectedTab: $selectedTab)
                .padding(.bottom, -20)
              .zIndex(1)
        }
      }
    
    @ViewBuilder
    private var mainView: some View {
        CustomSlideView(dragEnabled: true) {
            MainView(
               // viewModel: mainViewModel,
                selectedTab: $selectedTab,
                subViewModel: subViewModel
            )
            .environmentObject(authVM)
            //.environmentObject(iapViewModel)
        }
    }

    @ViewBuilder
    private var metersView: some View {
        CustomSlideView(dragEnabled: true) {
            MetersView(
                viewModel: metersViewModel,
                selectedTab: $selectedTab,
                subViewModel: subViewModel
            )
            .environmentObject(authVM)
           // .environmentObject(iapViewModel)
        }
    }

    @ViewBuilder
    private var consumptionsView: some View {
  
            ConsumptionsView(
                viewModel: readingsViewModel,
                meterVM: metersViewModel, selectedTab: $selectedTab,
                subViewModel: subViewModel
            )
            .environmentObject(authVM)
            
            // .environmentObject(iapViewModel)
        
      //  .environmentObject(authVM)
    }
    

    @ViewBuilder
    private var readingsView: some View {
        CustomSlideView(dragEnabled: true) {
            ReadingsView(
                viewModel: readingsViewModel,
                selectedTab: $selectedTab,
                subViewModel: subViewModel
            )
            .environmentObject(authVM)
          //  .environmentObject(iapViewModel)
        }
    }

    @ViewBuilder
    private var settingsView: some View {
        CustomSlideView(dragEnabled: true) {
            SettingsView(
                viewModel: settingsViewModel,
                selectedTab: $selectedTab,
                subViewModel: subViewModel
            )
            .environmentObject(authVM)
           // .environmentObject(iapViewModel)
        }
    }
    
    }

            //      MapMainView(
            //        viewModel: locationViewModel,
            //        selectedTab: $selectedTab,
            //        isKeyboardVisible: $isKeyboardVisible,
            //        sheetState: $sheetState,
            //        subViewModel: subViewModel,
            //        createViewModel: createViewModel
            //      )
            //      .environment(\.placesService, placesService)
            //      .environmentObject(permissionManager)
            //      .environmentObject(circleMembersService)
            //      .ignoresSafeArea()
            //
            //
            //      VStack {
            //        switch selectedTab {
            //        case .circles:
            //          circlesView
            //        case .places:
            //          placesView
            //        case .settings:
            //          settingsView
            //        }
            //      }
            //
            //
            //      if sheetState == .navigationBar || sheetState == .partial {
            //        ScrollView(.horizontal, showsIndicators: false) {
            //          HStack(spacing: 12) {
            //            if !permissionManager.checkFeaturePermissions(.locationSharing) && showLocationCard {
            //              PermissionCardView(
            //                title: "Allow Location Sharing",
            //                description: "To keep your location visible even when you're not using the app, tap Allow > Location and change the setting to Always.",
            //                showCard: $showLocationCard
            //              ) {
            //                if permissionManager.locationPermissionStatus == .notDetermined {
            //                  if let url = URL(string: UIApplication.openSettingsURLString) {
            //                    UIApplication.shared.open(url)
            //                  }
            //                } else {
            //                  showLocationCard = false
            //                }
            //              }
            //              .frame(width: UIScreen.main.bounds.width * 0.85)
            //            }
            //
            //            if !permissionManager.checkFeaturePermissions(.sos) && showNotificationsCard {
            //              PermissionCardView(
            //                title: "Allow Notifications",
            //                description: "Get alerts when circle members come and go.\nTap “Allow” > “Notifications” > turn the switch on.",
            //                showCard: $showNotificationsCard
            //              ) {
            //                if permissionManager.notificationPermissionStatus == .notDetermined {
            //                  if let url = URL(string: UIApplication.openSettingsURLString) {
            //                    UIApplication.shared.open(url)
            //                  } else {
            //                    showNotificationsCard = false
            //                  }
            //                }
            //              }
            //              .frame(width: UIScreen.main.bounds.width * 0.85)
            //            }
            //
            //            if permissionManager.motionPermissionStatus != .authorized && showMotionCard {
            //              PermissionCardView(
            //                title: "Allow Motion Activity",
            //                description: "Allow the app to track your device's motion activity to make location more accurate.\nTap 'Allow' > turn 'Motion & Fitness' on.",
            //                showCard: $showMotionCard
            //              ) {
            //                if permissionManager.motionPermissionStatus == .notDetermined {
            //                  Task {
            //                    _ = await permissionManager.requestMotionPermission()
            //                  }
            //                } else {
            //
            //                  guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            //                  UIApplication.shared.open(settingsUrl)
            //
            //                  showMotionCard = false
            //                }
            //              }
            //              .frame(width: UIScreen.main.bounds.width * 0.85)
            //            }
            //          }
            //          .padding(.horizontal, 10)
            //        }
            //        .padding(.bottom, sheetState == .navigationBar ? screenHeight * 0.13 : screenHeight * 0.5)
            //      }
            //
            //
            //      if showingCreatePlace && !isKeyboardVisible {
            //        PlaceSizePillView(viewModel: createViewModel)
            //          .padding(.bottom, screenHeight * 0.5)
            //      }
            //
            //
            //      if !isKeyboardVisible && !showingCreatePlace {
            //        CustomTabBarView(selectedTab: $selectedTab)
            //          .background(Color.clear)
            //          .zIndex(1)
            //      }
            //    }
            //    .navigationBarHidden(true)
            //    .task {
            //
            //      if !hasCheckedPermissions {
            //        await checkAndRequestPermissions()
            //        hasCheckedPermissions = true
            //      }
            //      startServices()
            //
            //
            //      if let userId = authVM.appUser?.id {
            //        circleMembersService.startListeningToMembers(memberIds: [userId])
            //      }
            //    }
            //    .onDisappear {
            //      stopServices()
            //    }
            //  }
            //
            //
            //
            //  private func checkAndRequestPermissions() async {
            //    print("🔐 Checking app permissions...")
            //
            //    let locationGranted = await permissionManager.requestLocationPermission(always: true)
            //    print("📍 Location permission status: \(locationGranted ? "Granted" : "Denied")")
            //
            //    let notificationGranted = await permissionManager.requestNotificationPermission()
            //    print("🔔 Notification permission status: \(notificationGranted ? "Granted" : "Denied")")
            //
            //    let motionGranted = await permissionManager.requestMotionPermission()
            //    print("🏃‍♂️ Motion permission status: \(motionGranted ? "Granted" : "Denied")")
            //
            //    if !locationGranted || !notificationGranted {
            //      print("⚠️ Critical permissions denied - user should check settings")
            //    }
            //  }
            //
            //  private func startServices() {
            //
            //    if permissionManager.locationPermissionStatus == .authorizedAlways ||
            //        permissionManager.locationPermissionStatus == .authorizedWhenInUse {
            //      locationViewModel.startLocationUpdates()
            //
            //      if (authVM.appUser?.id) != nil {
            //        if let locationService = locationViewModel.userService as? UserLocationService {
            //          locationService.startListeningToCircleMembers()
            //        }
            //      }
            //    } else {
            //      print("⚠️ Location services not started - missing permissions")
            //    }
            //  }
            //
            //  private func stopServices() {
            //    locationViewModel.stopLocationUpdates()
            //    circleMembersService.stopListening()
            //  }
            //
            //
            //  @ViewBuilder
            //  private var circlesView: some View {
            //    CustomSlideView(state: $sheetState, dragEnabled: true) {
            //      CirclesView(subViewModel: subViewModel, sheetState: $sheetState)
            //        .environmentObject(authVM)
            //        .environmentObject(circleMembersService)
            //    }
            //  }
            //
            //  @ViewBuilder
            //  private var placesView: some View {
            //    CustomSlideView(state: $sheetState, dragEnabled: !showingCreatePlace) {
            //      PlacesView(
            //        isKeyboardVisible: $isKeyboardVisible,
            //        sheetState: $sheetState,
            //        showingCreatePlace: $showingCreatePlace
            //      )
            //      .environmentObject(locationViewModel)
            //      .environmentObject(createViewModel)
            //      .onDisappear {
            //        showingCreatePlace = false
            //      }
            //      .background(Color.clear)
            //    }
            //  }
            //
            //  @ViewBuilder
            //  private var settingsView: some View {
            //    CustomSlideView(state: $sheetState, dragEnabled: true) {
            //      SettingsView(subViewModel: subViewModel, sheetState: $sheetState)
            //    }
            //  }
        
        
        //struct PermissionCardView: View {
        //  let title: String
        //  let description: String
        //  let showCard: Binding<Bool>
        //  let action: () -> Void
        //
        //  var body: some View {
        //    RoundedRectangle(cornerRadius: 12)
        //      .fill(Color.App.black.opacity(0.8))
        //      .frame(maxWidth: .infinity)
        //      .frame(height: 165)
        //      .overlay {
        //        VStack(alignment: .leading, spacing: 6) {
        //
        //          HStack {
        //
        //            Text(title)
        //                  .font(.SFPro.medium20)
        //                  .foregroundStyle(Color(hex: "#A6C549"))
        //
        //            Spacer()
        //
        //            Button {
        //              withAnimation {
        //                showCard.wrappedValue = false
        //              }
        //            } label: {
        //              Image(systemName: "xmark")
        //                    .foregroundColor(Color(hex: "#A6C549"))
        //                .frame(width: 24)
        //            }
        //          }
        //          .padding(.bottom, 4)
        //
        //
        //          Text(description)
        //                .font(.SFPro.regular14)
        //                .foregroundStyle(.white)
        //            .frame(height: 43)
        //            .lineLimit(4)
        //            .padding(.bottom, 10)
        //            .padding(.trailing, 10)
        //
        //
        //          Button(action: action) {
        //            Text("Allow")
        //              .font(.SFPro.medium16)
        //              .foregroundStyle(Color(hex: "#A6C549"))
        //              .frame(maxWidth: .infinity)
        //              .frame(height: 46)
        //              .background(Color(hex: "#1E2E3F"))
        //              .cornerRadius(12)
        //          }
        //        }
        //        .padding()
        //      }
        //  }
        //}
        //
        //#Preview{
        //  ScrollView(.horizontal, showsIndicators: false) {
        //    HStack(spacing: 12) {
        //      PermissionCardView(
        //        title: "Allow Location Sharing",
        //        description: "To keep your location visible even when you're not using the app, tap Allow > Location and change the setting to Always.",
        //        showCard: .constant(true)
        //      ) {
        //        if let url = URL(string: UIApplication.openSettingsURLString) {
        //          UIApplication.shared.open(url)
        //        }
        //      }
        //      .frame(width: UIScreen.main.bounds.width * 0.85)
        //
        //      PermissionCardView(
        //        title: "Enable Notifications",
        //        description: "Get alerts when circle members come and go. Tap “Allow” > “Notifications” > turn the switch on.",
        //        showCard: .constant(true)
        //      ) {
        //        if let url = URL(string: UIApplication.openSettingsURLString) {
        //          UIApplication.shared.open(url)
        //        }
        //      }
        //      .frame(width: UIScreen.main.bounds.width * 0.85)
        //    }
        //  }
        //
        //}
    

