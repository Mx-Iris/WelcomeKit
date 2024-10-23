import AppKit

class ProjectCellView: TableCellView {
    lazy var iconImageView = NSImageView()

    lazy var titleLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.maximumNumberOfLines = 1
        $0.textColor = .controlTextColor
    }

    lazy var detailLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 11, weight: .regular)
        $0.maximumNumberOfLines = 1
        $0.textColor = .secondaryLabelColor
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        iconImageView.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: leftAnchor)
            make.centerYAnchor.constraint(equalTo: centerYAnchor)
            make.widthAnchor.constraint(equalToConstant: 32)
            make.heightAnchor.constraint(equalToConstant: 32)
        }

        titleLabel.makeConstraints { make in
            make.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8)
            make.rightAnchor.constraint(equalTo: rightAnchor)
        }

        detailLabel.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
            make.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            make.rightAnchor.constraint(equalTo: rightAnchor)
        }

        titleLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        detailLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}
