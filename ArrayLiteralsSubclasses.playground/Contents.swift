
public protocol Styleable: ExpressibleByArrayLiteral {
    associatedtype Style: Attributed
    associatedtype Element = Style.Attribute
}

public protocol EmptyInitializable {
    associatedtype Styled
    static func createEmpty() -> Styled
}

public protocol Makeable: EmptyInitializable, Styleable {
    static func make(_ attributes: [Style.Attribute]) -> Styled
    func postMake(_ style: Style)
}

public extension Styleable where Self: Makeable, Self.Styled == Self, Self.Style.Attribute == Element {
    init(arrayLiteral elements: Self.Element...) {
        self = Self.make(elements)
    }
}

public extension Styleable where Self: Composable, Self.Style.Attribute == Element {
    init(arrayLiteral elements: Self.Element...) {
        self.init(Style(elements))
    }
}

extension Makeable {
    
    public func postMake(_ style: Style) {}
    
    // Using ArrayLiterals
    public static func make(_ elements: Style.Attribute...) -> Styled {
        return make(elements)
    }
    
    public static func make(_ attributes: [Style.Attribute]) -> Styled {
        let style: Style = attributes.merge(slave: []) // do not allow duplicates
        return make(style)
    }
    
    public static func make(_ style: Style) -> Styled {
        let view: Styled = createEmpty()
        if let selfStylable = view as? Self {
            selfStylable.setup(with: style)
            selfStylable.postMake(style)
        }
        return view
    }
}

// Makes (pun intended) it possible to write `let label: UILabel = make([.text("hi")])` notice the lack of `.` in `.make`.
public func make<M: Makeable>(_ attributes: [M.Style.Attribute]) -> M where M.Styled == M {
    return M.make(attributes)
}

// Array literals support
public func make<M: Makeable>(_ attributes: M.Style.Attribute...) -> M where M.Styled == M {
    return make(attributes)
}

public protocol Composable: Styleable {
    init(_ style: Style?)
    func setupSubviews(with style: Style)
}

extension Composable {
    public func setupSubviews(with style: Style) {}
}

public extension Styleable {
    func setup(with style: Style) {
        style.install(on: self)
    }
}
