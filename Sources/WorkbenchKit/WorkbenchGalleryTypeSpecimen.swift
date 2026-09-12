import SwiftUI

/// The three registers set together, because the only way to judge a label register is beside the
/// value it labels — and the status ramp beside itself, because hot-to-cold is a comparison.
public struct WorkbenchGalleryTypeSpecimen: View {
    public init() {}

    public var body: some View {
        WorkbenchBlock {
            WorkbenchBlockHeader(kicker: "Registers", title: "Type")
        } content: {
            VStack(alignment: .leading, spacing: 0) {
                WorkbenchRow {
                    HStack(alignment: .firstTextBaseline, spacing: WorkbenchMetrics.blockHInset) {
                        // STATUS tones only. `spotlight` is the action colour and is never on the
                        // ramp; drawing it in this row is the misuse the tone's own doc names.
                        ForEach(WorkbenchPalette.Tone.allCases.filter { $0 != .spotlight },
                                id: \.self) { tone in
                            VStack(alignment: .leading, spacing: 2) {
                                Text("128")
                                    .font(WorkbenchTypography.number)
                                    .foregroundStyle(WorkbenchPalette.color(tone))
                                Text(tone.rawValue)
                                    .labelRegister()
                            }
                        }
                    }
                }
                Rectangle()
                    .fill(WorkbenchPalette.hairlineSoft.color)
                    .frame(height: WorkbenchMetrics.hairlineWidth)
                WorkbenchRow {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("A block's name")
                            .font(WorkbenchTypography.blockTitle)
                            .foregroundStyle(WorkbenchPalette.textPrimary.color)
                        Text("Prose you read, at the reading register, on the block fill.")
                            .font(WorkbenchTypography.reading)
                            .foregroundStyle(WorkbenchPalette.textPrimary.color)
                        Text("Supporting prose beside it, one level down.")
                            .font(WorkbenchTypography.supporting)
                            .foregroundStyle(WorkbenchPalette.textSecondary.color)
                    }
                }
            }
        }
    }
}
