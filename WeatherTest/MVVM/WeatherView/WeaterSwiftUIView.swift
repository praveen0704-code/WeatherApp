//
//  WeaterSwiftUIView.swift
//  WeatherTest
//
//  Created by PraveenMAC on 23/11/24.
//

import SwiftUI
import UIKit

struct WeaterSwiftUIView: View {
    @StateObject private var viewModel = WeatherViewModel()
        @State private var cityName: String = ""
        @AppStorage("lastCityName") private var lastCityName: String = ""
    @StateObject private var weatherNavigationViewModel = NavigationViewModel()


        var body: some View {
            NavigationStack {
                ZStack {
                    Image("weatherBackroundImg")
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack{
                        Text("Weather")
                            .font(.system(size: 30)) // Set font size to 24
                            .bold().foregroundColor(.white)
                            Spacer()
                        }.padding()
                        Spacer(minLength: 10)
                        
                        // Search Section
                        HStack {
                            TextField("Enter city name", text: $cityName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            Button(action: {
                                if !cityName.isEmpty {
                                    lastCityName = cityName
                                    viewModel.fetchWeather(for: cityName)
                                    viewModel.fetchForecast(for: cityName)
                                    cityName = ""
                                    UIApplication.shared.endEditing() // Dismiss the keyboard

                                }
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Loading Indicator
                        if viewModel.isLoading {
                            ProgressView("Fetching Weather...")
                                .padding()
                        }
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        // Current Weather Section
                        if let weather = viewModel.currentWeather {
                            VStack(spacing: 15) {
                                Text(weather.name)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text("\(Int(weather.main.temp))°C")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white)
                                
                                Text(weather.weather.first?.description.capitalized ?? "")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            //.padding()
                        }
                        
                        // 5-Day Forecast Section with ScrollView
                        if !viewModel.forecast.isEmpty {
                            VStack(alignment: .leading) {
                                Text("5-Day Forecast")
                                    .font(.headline)
                                    .padding(.top)
                                    .foregroundColor(.white)
                                
                                ScrollView {
                                    VStack(spacing: 10) {
                                        ForEach(viewModel.forecast) { dailyForecast in
                                            HStack {
                                                Text(dailyForecast.date)
                                                Spacer()
                                                Text("Min: \(Int(dailyForecast.minTemp))°C")
                                                Spacer()
                                                Text("Max: \(Int(dailyForecast.maxTemp))°C")
                                            }
                                            .padding()
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(10)
                                            .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.top,10)
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
            }
            .onAppear {
                weatherNavigationViewModel.setupNavigationBarAppearance()

                if !lastCityName.isEmpty {
                    viewModel.fetchWeather(for: lastCityName)
                    viewModel.fetchForecast(for: lastCityName)
                }
            }
        }
    }
