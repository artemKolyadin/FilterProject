//
//  ServerManager.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import Foundation

class ServerManager {
    
    private init() {}
    static let shared = ServerManager()
    
    func getMainFilters (completion:@escaping ([CheckBoxFilter]?)-> Void) {
        let string = """
        [
            {
                \"_id\": \"1\",
                \"name\": \"Закрепленный фильтр 1\",
                \"description\": \"Описание фильтра\"
            }
        ]
        """
        let data = string.data(using: .utf8)!
        do {
            let filters = try JSONDecoder().decode([CheckBoxFilter].self,from: data)
            completion(filters)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    
    func getOtherFilters (completion:@escaping ([CheckBoxFilter]?)-> Void) {
        let string = """
[{
                \"_id\": \"4\",
                \"name\": \"Фильтр 1\",
                \"description\": \"Описание фильтра\"
            },
            {
                \"_id\": \"5\",
                \"name\": \"Фильтр 2\",
                \"description\": \"Описание фильтра\"
            },
            {
                \"_id\": \"6\",
                \"name\": \"Фильтр 3\",
                \"description\": \"Описание фильтра\"
            },
            {
                \"_id\": \"7\",
                \"name\": \"Фильтр 4\",
                \"description\": \"Описание фильтра\"
            },
            {
                \"_id\": \"8\",
                \"name\": \"Фильтр 5\",
                \"description\": \"Описание фильтра\"
            }]
"""
        let data = string.data(using: .utf8)!
        do {
            let filters = try JSONDecoder().decode([CheckBoxFilter].self, from: data)
            completion(filters)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    func getAttributeFilters (completion: @escaping ([AttributeFilter]?)-> Void) {
        let string = """
        [
            {
                \"_id\": \"9\",
                \"name\": \"Аттрибут 1\",
                \"description\": \"Описание фильтра\"
            },
            {
                \"_id\": \"10\",
                \"name\": \"Аттр. 2\",
                \"description\": \"Описание фильтра\"
            }
        ]
        """
        let data = string.data(using: .utf8)!
        do {
            let filters = try JSONDecoder().decode([AttributeFilter].self, from: data)
            completion(filters)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    
}

