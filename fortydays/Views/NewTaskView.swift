import SwiftUI

struct NewTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    var onSave: (() -> Void)? = nil

    @State private var selectedCategory: TaskCategory = .moustache
    @State private var lastTaskDate = Date()
    @State private var applyToAll: Bool = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Primary-100").opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Form {
                        Section(header: Text("Détails du rituel")) {
                            Toggle("Appliquer à tous les rituels", isOn: $applyToAll)

                            if !applyToAll {
                                Picker("Catégorie du rituel", selection: $selectedCategory) {
                                    ForEach(TaskCategory.allCases) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                            }

                            DatePicker("Date du rituel", selection: $lastTaskDate, displayedComponents: .date)
                        }

                        Section {
                            Button(action: {
                                if applyToAll {
                                    for category in TaskCategory.allCases {
                                        taskViewModel.addOrUpdateTask(for: category, with: lastTaskDate)
                                    }
                                } else {
                                    taskViewModel.addOrUpdateTask(for: selectedCategory, with: lastTaskDate)
                                }

                                onSave?()
                                dismiss()
                            }) {
                                Text(applyToAll ? "Enregistrer tous les rituels" : "Enregistrer le rituel")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("Primary-900"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("Nouveau rituel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(taskViewModel: TaskViewModel())
    }
}
