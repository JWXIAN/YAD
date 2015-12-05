//
//  Tool-swift.swift
//  JXT
//
//  Created by 1039soft on 15/8/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit
import Foundation
class Tool_swift: NSObject {

    /**
    去除数组中重复对象
    @param array 要去重的数组
    @return 处理好的数组
    **/
    class func arrayWithMemberIsOnly(array:NSArray) ->NSArray
    {
      let 我才不是要返回的数组呢 = NSMutableArray()
        
        for var i=0; i<array.count;i++
        {
            if 我才不是要返回的数组呢.containsObject(array.objectAtIndex(i))==false
            {
                我才不是要返回的数组呢.addObject(array.objectAtIndex(i))
            }

        }
        return 我才不是要返回的数组呢
    }
    
    
    //根据所给内容对数组进行分组
    /**
    
    @param array  分组根据
    @param array2  要分组的数组
    @param key 根据数组中对象的哪一个值进行分组
    @return 分好组的数组
    **/
    class func requirementArray(array:NSArray, array2:NSArray, key:String) ->NSArray
    {
       let 我才不是要返回的数组呢=NSMutableArray()
        for var i=0;i<array.count;i++
        {
            let 我是临时变量=NSMutableArray()
            for var j=0;j<array2.count;j++
            {
                if array2[j].valueForKey(key)!.isEqualToString(array[i] as! String)
                {
                    我是临时变量.addObject(array2[j])
                }
            }
            我才不是要返回的数组呢.addObject(我是临时变量)
        }
        return 我才不是要返回的数组呢
    }
    
}
