import SwiftUI

/// One cell of an instrument cluster: the reading in the number register over its name in the
/// label register, filling whatever the grid gives it so its neighbours never sit taller.
public struct WorkbenchCellView: View {
    private let cell: WorkbenchCell

    public init(_ cell: WorkbenchCell) {
        self.cell = cell
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(cell.value)
                .font(WorkbenchTypography.number)
                .foregroundStyle(colour)
            Text(cell.label)
                .labelRegister()
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, WorkbenchMetrics.blockHInset)
        .padding(.vertical, WorkbenchMetrics.blockRowVInset)
        .background(WorkbenchPalette.block.color)
        // One reading, read as one thing: "3, Critical" rather than two stops.
        .accessibilityElement(children: .combine)
    }

    private var colour: Color {
        guard let tone = cell.tone else { return WorkbenchPalette.textPrimary.color }
        return WorkbenchPalette.color(tone)
    }
}
