//
//  CatSearchView.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 22/12/24.
//

import SwiftUI
import Combine

struct CatSearchView: View {
    
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            TextField("Search cats...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }

            if viewModel.items.isEmpty && !viewModel.isLoading {
                Text("No result, 🐈")
                    .padding()
            } else {
                CatListView(
                    items: viewModel.items,
                    onActionSelected: viewModel.onListAction
                )
            }
        }
        .task {
            await viewModel.loadItems()
        }
    }
}

extension CatSearchView {
    
    typealias SearchAction = (Action) -> Void
    
    enum Action {
        case didSelectItem(CatItem)
        case showError(String)
    }
    
    //TODO: avoid boolean and use a state machine
    final class ViewModel: ObservableObject {
        @Published var searchText: String = ""
        @Published var items: [CatItem] = []
        @Published var isLoading: Bool = false

        private var cancellables = Set<AnyCancellable>()
        private var currentPage = 1
        private var hasNextPage = true
        
        private let repository: CatRepository
        private let onActionSelected: SearchAction
        
        init(repository: CatRepository = CatRepositoryImpl(), 
             onActionSelected: @escaping SearchAction = { _ in }) {
            self.repository = repository
            self.onActionSelected = onActionSelected
            
//            setupSearchBinding()
        }
        
        func onListAction(action: CatListView.Action) {
            switch action {
            case .image(let catItem):
                onActionSelected(.didSelectItem(catItem))
            case .favourite(let catItem):
                break //TODO: call API
            case .lastItem(let catItem):
                loadNextPage()
            }
        }
        
        @MainActor
        func loadItems() async {
            guard hasNextPage, !isLoading else { return }
            isLoading = true
            
            do {
                let newItems = try await repository.fetchCats(limit: 20, page: currentPage)
                hasNextPage = !newItems.isEmpty
                isLoading = false
                items.append(contentsOf: newItems.map { .init($0) })
            } catch {
                isLoading = false
                onActionSelected(.showError(error.localizedDescription))
            }
        }
        
        private func loadNextPage() {
            Task {
                currentPage += 1
                await loadItems()
            }
        }
        
        private func setupSearchBinding() {
            $searchText
                .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] query in
                    self?.performSearch(query: query)
                }
                .store(in: &cancellables)
        }
        
        private func performSearch(query: String) {
            isLoading = true
            
        }
    }
}

#Preview {
    CatSearchView(viewModel: CatSearchView.ViewModel())
}
