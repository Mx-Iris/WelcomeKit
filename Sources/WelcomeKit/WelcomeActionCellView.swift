import AppKit

class WelcomeActionCellView: TableCellView {
    lazy var iconImageView = NSImageView()

    lazy var titleLabel = NSTextField(labelWithString: "")

    lazy var detailLabel = NSTextField(labelWithString: "")

    let style: WelcomeStyle

    let normalBackgroundColor = NSColor(name: "WelcomeActionCellView.normalBackgroundColor") {
        $0.isDark ? .white.withAlphaComponent(0.03) : .black.withAlphaComponent(0.05)
    }

    let highlightBackgroundColor = NSColor(name: "WelcomeActionCellView.highlightBackgroundColor") {
        $0.isDark ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.08)
    }

    var didClick: () -> Void = { }
    
    init(style: WelcomeStyle) {
        self.style = style
        super.init(frame: .zero)

        switch style {
        case .xcode14:
            addSubview(iconImageView)
            addSubview(titleLabel)
            addSubview(detailLabel)

            iconImageView.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: leftAnchor)
                make.centerYAnchor.constraint(equalTo: centerYAnchor)
                make.widthAnchor.constraint(equalToConstant: 35)
                make.heightAnchor.constraint(equalToConstant: 35)
            }

            titleLabel.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 15)
                make.topAnchor.constraint(equalTo: topAnchor, constant: 9)
                make.rightAnchor.constraint(equalTo: rightAnchor)
            }

            detailLabel.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
                make.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
                make.rightAnchor.constraint(equalTo: rightAnchor)
            }

            iconImageView.do {
                $0.contentTintColor = .controlAccentColor
            }

            titleLabel.do {
                $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }

            detailLabel.do {
                $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }

        case .xcode15:
            addSubview(iconImageView)
            addSubview(titleLabel)

            cornerRadius = 8
            backgroundColor = normalBackgroundColor
            iconImageView.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: leftAnchor, constant: 11.5)
                make.centerYAnchor.constraint(equalTo: centerYAnchor)
                make.widthAnchor.constraint(equalToConstant: 24)
            }

            titleLabel.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 11)
                make.centerYAnchor.constraint(equalTo: centerYAnchor)
                make.rightAnchor.constraint(equalTo: rightAnchor)
            }

            titleLabel.do {
                $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }
        }
    }

    override func mouseDown(with event: NSEvent) {
        if style == .xcode15 {
            backgroundColor = highlightBackgroundColor
        }
    }

    override func mouseUp(with event: NSEvent) {
        if style == .xcode15 {
            backgroundColor = normalBackgroundColor
        }
        didClick()
    }
}
