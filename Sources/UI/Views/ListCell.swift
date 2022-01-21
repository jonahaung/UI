//
//  FormCell.swift
//  MyBike
//
//  Created by Aung Ko Min on 10/12/21.
//

import SwiftUI

public struct ListCell<Left: View, Right: View>: View {
    
    private let leftView: () -> Left
    private let rightView: () -> Right
    private let iconName: String?
    private let showDivider: Bool
    private var iconWidth: CGFloat { iconName == nil ? 0 : 25 }
    
    public init(iconName: String? = nil, showDivider: Bool = true, @ViewBuilder leftView: (@escaping () -> Left), @ViewBuilder rightView: (@escaping () -> Right)) {
        self.leftView = leftView
        self.rightView = rightView
        self.iconName = iconName
        self.showDivider = showDivider
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            if let iconName = iconName {
                Image(systemName: iconName).foregroundColor(Color(uiColor: .tertiaryLabel))
                    .scaledToFit()
                    .frame(width: iconWidth, height: iconWidth)
            }
            leftView()
            Spacer()
            rightView()
        }
        if showDivider {
            Divider().padding(.leading, iconWidth + (iconName == nil ? 0 : 8))
        }
    }
}
