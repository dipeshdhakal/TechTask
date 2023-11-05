//
//  Selectable.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 31/10/2023.
//

import Foundation
import SwiftUI

/// Defines a way to select/deselect an item
protocol Selectable: AnyObject {
    var selectableIsSelected: Bool { get set }
}

/// Defines a generic element that has a selected state.
class Selected<Element> {
    var element: Element
    var selected: Bool

    init(element: Element, selected: Bool) {
        self.element = element
        self.selected = selected
    }
}

extension Selected: Selectable {
    var selectableIsSelected: Bool {
        get {
            return selected
        }

        set {
            selected = newValue
        }
    }
}

extension Selected {
    var color: Color {
        return selectableIsSelected ? Color.brandColor : Color.primary
    }
}


extension Selected: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
