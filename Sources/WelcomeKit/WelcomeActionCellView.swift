import AppKit

class WelcomeActionCellView: TableCellView {
    let iconImageView = NSImageView().then {
        $0.imageScaling = .scaleProportionallyUpOrDown
    }

    let titleLabel = NSTextField(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }

    let detailLabel = NSTextField(labelWithString: "").then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }

    init() {
        super.init(frame: .zero)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
//        iconImageView.snp.makeConstraints { make in
//            make.left.centerY.equalToSuperview()
//            make.size.equalTo(35)
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(iconImageView.snp.right).offset(15)
//            make.top.equalToSuperview().offset(2)
//        }
//        detailLabel.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel)
//            make.bottom.equalToSuperview().offset(-2)
//        }
        
        iconImageView.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: leftAnchor)
            make.centerYAnchor.constraint(equalTo: centerYAnchor)
            make.widthAnchor.constraint(equalToConstant: 35)
            make.heightAnchor.constraint(equalToConstant: 35)
        }
        titleLabel.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 15)
            make.topAnchor.constraint(equalTo: topAnchor, constant: 2)
        }
        detailLabel.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
            make.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        }
    }
    
    override var intrinsicContentSize: NSSize {
        return .init(width: NSView.noIntrinsicMetric, height: 40)
    }
}
