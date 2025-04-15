import SwiftUI

struct CircleProgressView: View {
    let days: Int
    let maxDays: Int
    
    private var progressRatio: CGFloat {
        return CGFloat(days) / CGFloat(maxDays)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("Primary-100"), lineWidth: 30)
                .frame(width: 220, height: 220)
            
            Circle()
                .trim(from: 0, to: progressRatio)
                .stroke(Color("Primary-900"), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("\(days)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(Color("Primary-900"))
                
                Text("jours restants")
                    .font(.system(size: 16))
                    .foregroundColor(Color("Primary-500"))
            }
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView(days: 32, maxDays: 40)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
