import SwiftUI

struct TaskCard: View {
    let task: TaskModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.category.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("Primary-900"))
                
                Text("Dernière fois il y a \(task.daysSince) jours")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("J-\(task.daysLeft)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color("Primary-100"))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color("Primary-900"))
                .cornerRadius(20)
        }
        .padding(15)
        .background(Color("Primary-100"))
        .cornerRadius(15)
    }
}

struct TaskCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = TaskModel(
            category: .moustache,
            lastCompletionDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        )
        
        return TaskCard(task: sampleTask)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
