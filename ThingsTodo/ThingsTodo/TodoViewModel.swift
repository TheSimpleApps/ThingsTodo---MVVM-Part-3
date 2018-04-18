//
//  TodoViewModel.swift
//  ThingsTodo
//
//  Created by Karamjeet Singh on 17/04/18.
//  Copyright © 2018 TheSimpleApps@gmail.com. All rights reserved.
//

protocol ToDoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
}

class TodoItemViewModel: ToDoItemPresentable {
    var id : String? = "0"
    var textValue : String?
    
    init(id: String, textValue: String) {
        self.id = id
        self.textValue = textValue
    }
}

protocol TodoViewDelegate {
    // Add item
    func  onToDoItemAdded() -> ()
    
    // Delete item
    func onToDoItemDelete(itemId: String)
}

protocol TodoViewPresentable {
    var newTodoValue: String? { get }
}


protocol TodoItemViewDelegate {
    func onItemSelected() -> (Void)
}



class TodoViewModel: TodoViewPresentable {
    
    weak var view: TodoViewUpdate?
    var newTodoValue: String?
    var items : [ToDoItemPresentable] = []
    init(view: TodoViewUpdate) {
        self.view = view
        
        //Create some dummy items if you want
        let item1 = TodoItemViewModel(id: "1", textValue: "item 1")
        let item2 = TodoItemViewModel(id: "2", textValue: "item 2")
        let item3 = TodoItemViewModel(id: "3", textValue: "item 3")
        
        items.append(contentsOf: [item1, item2, item3])
    }
}


extension TodoItemViewModel: TodoItemViewDelegate {
    
    func onItemSelected() {
        print("item selected  id = \(id!) item = \(textValue!)")
    }
    
}

extension TodoViewModel: TodoViewDelegate {
   
    // Delete item
    func onToDoItemDelete(itemId: String) {
    
        guard let index = self.items.index(where: {$0.id! == itemId}) else {
            print("item index not present")
            return
        }
        
        self.items.remove(at: index)
        self.view?.itemRemoved(at: index)
    }
    
    
    
    // Add item
    
    func onToDoItemAdded() {
        
        print("New todo value received in view model: \(newTodoValue)")
        
        
        guard let newTodoValue = newTodoValue else {
            
            print("new value is empty")
            return
        }
        
        let itemIndex = items.count + 1
        let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newTodoValue)
        self.items.append(newItem)
        self.newTodoValue = ""
        self.view?.itemInserted()
    }
}
