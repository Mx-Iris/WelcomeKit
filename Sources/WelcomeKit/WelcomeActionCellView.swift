import AppKit

class WelcomeActionCellView: TableCellView {
    let iconImageView = NSImageView()

    let titleLabel = NSTextField(labelWithString: "")

    lazy var detailLabel = NSTextField(labelWithString: "")

    lazy var backgroundView = View()
    
    let style: WelcomeStyle
    
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
            }
            
            detailLabel.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
                make.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
            }
            
            iconImageView.do {
                $0.contentTintColor = .controlAccentColor
            }
        case .xcode15:
            addSubview(backgroundView, fill: true)
            addSubview(iconImageView)
            addSubview(titleLabel)
            
            backgroundView.cornerRadius = 8
            backgroundView.backgroundColor = .labelColor.withAlphaComponent(0.03)
            
            iconImageView.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: leftAnchor, constant: 11.5)
                make.centerYAnchor.constraint(equalTo: centerYAnchor)
                make.widthAnchor.constraint(equalToConstant: 24)
//                make.heightAnchor.constraint(equalToConstant: 24)
            }
            
            titleLabel.makeConstraints { make in
                make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 11)
                make.centerYAnchor.constraint(equalTo: centerYAnchor)
            }
        }
    }
}
