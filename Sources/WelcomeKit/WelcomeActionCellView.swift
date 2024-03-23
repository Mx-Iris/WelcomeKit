import AppKit

class WelcomeActionCellView: TableCellView {
    let iconImageView = NSImageView().then {
        $0.imageScaling = .scaleProportionallyUpOrDown
    }

    let titleLabel = NSTextField(labelWithString: "")

    let detailLabel = NSTextField(labelWithString: "")

    init() {
        super.init(frame: .zero)
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
    }
}
