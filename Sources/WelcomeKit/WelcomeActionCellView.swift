import AppKit
@_implementationOnly import SnapKit
@_implementationOnly import Then

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
        iconImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(35)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(2)
        }
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    override var intrinsicContentSize: NSSize {
        return .init(width: NSView.noIntrinsicMetric, height: 40)
    }
}
