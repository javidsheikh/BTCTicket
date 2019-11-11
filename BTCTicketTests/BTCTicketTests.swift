//
//  BTCTicketTests.swift
//  
//
//  Created by Javid Sheikh on 11/11/2019.
//

import Quick
import Nimble

class BTCTicketTests: QuickSpec {

    override func spec() {
        
        beforeEach {
            
        }
        
        describe("I am in the ticket scene") {
            
            context("I check the Bitcoin sell price") {
                it("it should update every 15 seconds with the current sell price") {
                    
                }
            }

            context("I check the Bitcoin buy price") {
                it("it should update every 15 seconds with the current buy price") {
                    
                }
            }
            
            context("the Bitcoin prices update") {
                it("the spread label should update accordingly") {
                    
                }
            }
            
            context("I input a number of units") {
                it("the amount text field should be automatically populated with the correct amount using the current buy price") {
                    
                }
            }
            
            context("I input an amount") {
                it("the units text field should be automatically populated with the correct number of units using the current buy price") {
                    
                }
            }
            
            context("the amount and unit text fields are empty") {
                it("the confirm button should be disable") {
                    
                }
            }
            
            context("the amount and unit text fields are populated") {
                it("the confirm button should be enabled") {
                    
                }
            }
        }
    }
}
