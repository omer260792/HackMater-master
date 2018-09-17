//
//  CustomSegues.swift
//  HackatonApp
//
//  Created by ido talmor on 18/02/2018.
//  Copyright © 2018 idotalmor. All rights reserved.
//

import UIKit

class SegueFromRight: UIStoryboardSegue {
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.height, y: 0)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                        src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.height, y: 0)
        },
                       completion: { finished in
                        if let navController = src.navigationController {
                            navController.pushViewController(dst, animated: false)
                            
                        } else {
                            src.present(dst, animated: false, completion: nil)
                        }            }
        )
    }}


class SegueFromLeft: UIStoryboardSegue {
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.height, y: 0)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                        src.view.transform = CGAffineTransform(translationX: src.view.frame.size.height, y: 0)
        },
                       completion: { finished in
                        if let navController = src.navigationController {
                            navController.pushViewController(dst, animated: false)
                            
                        } else {
                            src.present(dst, animated: false, completion: nil)
                        }            }
        )
    }}



