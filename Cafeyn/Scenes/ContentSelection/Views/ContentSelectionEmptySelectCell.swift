//
//  ContentSelectionEmptySelectCell.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import SwiftUI

struct ContentSelectionEmptySelectCell: View {
    var body: some View {
        VStack {
            HStack {
                Text("organise-interest-description".localised)
                    .fontWeight(.light)
                Spacer()
            }
            .padding(.bottom)

            VStack(alignment: .center) {
                Text("no-interest-selected".localised)
                    .fontWeight(.medium)
                    .padding(.top)
                Text("no-interest-selected-description".localised)
                    .multilineTextAlignment(.center)
                    .fontWeight(.light)
                    .padding([.horizontal, .bottom])
                    .frame(maxWidth: .infinity)
            }.background {
                RoundedRectangle(cornerRadius: 8, style: .continuous) // should be kept in design system, I'm not going to create one for simplicty
                    .foregroundStyle(Color.gray.opacity(0.1))
            }
        }
        .font(.system(size: 14))
    }
}

#Preview {
    ContentSelectionEmptySelectCell()
}
