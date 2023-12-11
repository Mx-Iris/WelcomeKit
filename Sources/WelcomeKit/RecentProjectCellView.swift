import AppKit

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

//        iconImageView.snp.makeConstraints { make in
//            make.left.centerY.equalToSuperview()
//            make.size.equalTo(32)
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(5)
//            make.left.equalTo(iconImageView.snp.right).offset(8)
//            make.right.greaterThanOrEqualToSuperview().offset(10)
//        }
//
//
//        detailLabel.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel)
//            make.bottom.equalToSuperview().inset(5)
//            make.right.greaterThanOrEqualToSuperview().offset(10)
//        }

        iconImageView.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: self.leftAnchor)
            make.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            make.widthAnchor.constraint(equalToConstant: 32)
            make.heightAnchor.constraint(equalToConstant: 32)
        }

        titleLabel.makeConstraints { make in
            make.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            make.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8)
            make.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: 10)
        }

        detailLabel.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
            make.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            make.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: 10)
        }

        titleLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        detailLabel.do {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
}

extension NSView: ConstraintMaker {}

protocol ConstraintMaker: NSView {}

extension ConstraintMaker {
    func makeConstraints(@ArrayBuilder<NSLayoutConstraint> _ constraintsBuilder: (_ make: Self) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraintsBuilder(self))
    }
}
