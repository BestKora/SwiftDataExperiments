//
//  SwiftDataExtension.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import SwiftData

extension ModelContext {
    func saveContext (){
         if self.hasChanges {
             do{
                 try self.save()
             } catch {
                 // We couldn't save :(
                 // Failures include issues such as an invalid unique constraint
                 print(error.localizedDescription)
             }
         }
     }
}
