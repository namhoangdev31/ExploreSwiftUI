import SwiftUI
import XCTest

@testable import UniSwiftUi

final class DatePickersSmokeTests: XCTestCase {
    @MainActor
    func testDatePickersContractsCompile() {
        _ = DatePickersSmokeView()
    }
}

private struct DatePickersSmokeView: View {
    @State private var date = Date()
    @State private var dates = Set<DateComponents>()
    var body: some View {
        VStack {
            UniDatePicker("Pick", selection: $date)
                .uniDatePickerStyle(.graphical)

            UniDatePicker("Range", selection: $date, in: Date()...)
                .uniDatePickerStyle(.wheel)

            UniMultiDatePicker(selection: $dates) {
                Text("Multi")
            }
        }
    }
}
