
public class Observable<T> {
    private lazy var observers = [Observer<T>]()
    
    public init(_ value: T) {
        self.value = value
    }
    
    public var value: T {
        didSet {
            self.cleanDeadObservers()
            for observer in self.observers {
                observer.closure(oldValue, self.value)
            }
        }
    }
    
    public func observe(_ observer: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.observers.append(Observer(owner: observer, closure: closure))
        self.cleanDeadObservers()
    }
    
    public func removeObserver(_ observer: AnyObject){
        self.observers = self.observers.filter { $0.owner !== observer }
    }
    
    public func isObserver(_ observer: AnyObject) -> Bool {
        return self.observers.contains(where: { $0.owner === observer })
    }
    
    private func cleanDeadObservers() {
        self.observers = self.observers.filter { $0.owner != nil }
    }
}

public class SingleObservable {
    private lazy var observers = [SingleObserver]()
    
    public init() { }
    
    func call(){
        self.cleanDeadObservers()
        for observer in self.observers {
            observer.closure()
        }
    }
    
    
    public func observe(_ observer: AnyObject, closure: @escaping () -> Void) {
        self.observers.append(SingleObserver(owner: observer, closure: closure))
        self.cleanDeadObservers()
    }
    
    public func removeObserver(_ observer: AnyObject){
        self.observers = self.observers.filter { $0.owner !== observer }
    }
    
    public func isObserver(_ observer: AnyObject) -> Bool {
        return self.observers.contains(where: { $0.owner === observer })
    }
    
    private func cleanDeadObservers() {
        self.observers = self.observers.filter { $0.owner != nil }
    }
}

private struct SingleObserver {
    weak var owner: AnyObject?
    let closure: () -> Void
    init (owner: AnyObject, closure: @escaping () -> Void) {
        self.owner = owner
        self.closure = closure
    }
}

private struct Observer<T> {
    weak var owner: AnyObject?
    let closure: (_ old: T, _ new: T) -> Void
    init (owner: AnyObject, closure: @escaping (_ old: T, _ new: T) -> Void) {
        self.owner = owner
        self.closure = closure
    }
}
