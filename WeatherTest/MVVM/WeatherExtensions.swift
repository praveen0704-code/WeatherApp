//
//  WeatherExtensions.swift
//  WeatherTest
//
//  Created by PraveenMAC on 23/11/24.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
