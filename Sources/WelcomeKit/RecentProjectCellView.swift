@_implementationOnly import Then
import AppKit
@_implementationOnly import SnapKit

class RecentProjectCellView: TableCellView {
    let iconImageView = NSImageView()

    let titleLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.maximumNumberOfLines = 1
        $0.textColor = .labelColor
    }

    let detailLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 11, weight: .regular)
        $0.maximumNumberOfLines = 1
        $0.textColor = .secondaryLabelColor
    }

    init() {
        super.init(frame: .zero)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        iconImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.right.greaterThanOrEqualToSuperview().offset(10)
        }
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(5)
            make.right.greaterThanOrEqualToSuperview().offset(10)
        }

        titleLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        detailLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
