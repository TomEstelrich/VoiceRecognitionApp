// 17.09.23 | VoiceRecognitionApp - Republished.swift | Tom Estelrich

import Combine
import Foundation

// MARK: Republished
/// Transmits '@Published' property values from nested ObservableObjects.
@propertyWrapper struct Republished<Object: ObservableObject> {
    
    // MARK: Lifecycle
    
    init(wrappedValue: Object) {
        self.storage = wrappedValue
    }
    
    // MARK: Internal
    
    var wrappedValue: Object {
        get { fatalError() }
        set { fatalError() }
    }
    
    static subscript<Enclosing: ObservableObject>(
        _enclosingInstance enclosing: Enclosing,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Object>,
        storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Republished<Object>>
    ) -> Object where Enclosing.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            if enclosing[keyPath: storageKeyPath].subscription == nil {
                let parentPublisher = enclosing.objectWillChange
                let childPublisher = enclosing[keyPath: storageKeyPath].storage.objectWillChange
                
                enclosing[keyPath: storageKeyPath].subscription = childPublisher
                    .receive(on: RunLoop.main)
                    .sink { _ in
                        parentPublisher.send()
                    }
            }
            
            return enclosing[keyPath: storageKeyPath].storage
        }
        
        set {
            if enclosing[keyPath: storageKeyPath].subscription != nil {
                enclosing[keyPath: storageKeyPath].subscription = nil
            }
            
            enclosing[keyPath: storageKeyPath].storage = newValue
            
            let parentPublisher = enclosing.objectWillChange
            let childPublisher = newValue.objectWillChange
            
            enclosing[keyPath: storageKeyPath].subscription = childPublisher
                .receive(on: RunLoop.main)
                .sink { _ in
                    parentPublisher.send()
                }
            
            parentPublisher.send()
        }
    }
    
    // MARK: Private
    
    private var storage: Object
    private var subscription: AnyCancellable? = nil
    
}
