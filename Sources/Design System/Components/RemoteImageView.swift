//
//  RemoteImageView.swift
//  CulinaryChronicles
//
//  Created by Mo Ahmad on 01/04/2023.
//

import Kingfisher
import SwiftUI

struct RemoteImageView: View {
    let imageURL: URL

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(uiColor: .secondarySystemBackground))

            KFImage(imageURL)
                .placeholder {
                    // Placeholder while downloading.
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .fade(duration: 0.25)
                .resizable()
                .layoutPriority(1)
                .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(imageURL: URL(string: "https://media.guim.co.uk/c15c453c8e89db724c3c427f8c37621701350894/70_7_2614_1568/500.jpg")!)
    }
}
