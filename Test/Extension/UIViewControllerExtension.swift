//
//  UIViewControllerExtension.swift
//  Test
//
//  Created by reyhan muhammad on 10/05/23.
//

import UIKit

extension UIViewController{
    func presentToastAlert(text: String){
        enum Animate{
            case animateIn
            case animateOut
        }
        
        if let view = view.subviews.first(where: {$0.tag == 999}){
            removeToast(view: view)
        }else{
            presentToast()
        }
        
        func presentToast(){
            let alert = UIView()
            alert.tag = 999
            alert.translatesAutoresizingMaskIntoConstraints = false
            alert.backgroundColor = .white
            view.addSubview(alert)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: alert, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: alert, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: alert, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: alert, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .trailing, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: alert, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])
            
            view.layoutIfNeeded()
            alert.addShadowAndCornerRadius(cornerRadius: alert.frame.height / 2)

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 12, weight: .semibold)
            label.numberOfLines = 0
            label.textAlignment = .center
            alert.addSubview(label)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: alert, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: alert, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: alert, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: alert, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            ])
            
            label.text = text
            
            view.layoutIfNeeded()
            animateAlert(alert, animate: .animateIn) {
                animateAlert(alert, animate: .animateOut) {
                    removeToast(view: alert)
                }
            }
        }
        
        func animateAlert(_ view: UIView, animate: Animate, completion: @escaping(() -> ())){
            let distance = view.frame.height + view.safeAreaInsets.bottom + 20
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: animate == .animateIn ? 1:0.2, initialSpringVelocity: animate == .animateIn ? 0.1:0.1) {
                switch animate {
                case .animateIn:
                    view.frame.origin.y -= distance
                case .animateOut:
                    view.frame.origin.y = self.view.frame.height
                }
            } completion: { complete in
                if complete{
                    completion()
                }
            }
            
        }
        
        func removeToast(view: UIView){
            view.removeFromSuperview()
        }
    }
}
