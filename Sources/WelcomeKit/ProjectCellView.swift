import AppKit

class ProjectCellView: TableCellView {
    let style: WelcomeStyle
    
    lazy var iconImageView = NSImageView()

    lazy var titleLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = style.projectCellTitleLabelFont
        $0.maximumNumberOfLines = 1
        $0.textColor = .controlTextColor
        $0.lineBreakMode = .byTruncatingTail
    }

    lazy var detailLabel: NSTextField = .init(labelWithString: "").then {
        $0.font = style.projectCellDetailLabelFont
        $0.maximumNumberOfLines = 1
        $0.textColor = .secondaryLabelColor
        $0.lineBreakMode = .byTruncatingTail
    }

    init(style: WelcomeStyle) {
        self.style = style
        super.init(frame: .zero)
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
