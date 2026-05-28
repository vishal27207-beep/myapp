import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Customerservice } from './customerservice';
import { Customermodel } from './customermodel';
@Component({
    selector: 'app-customer',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './customer.html',
    styleUrl: './customer.css',
})

export class Customer implements OnInit {

    customers: Customermodel[] = [];

    customer: Customermodel = {

        customerType: '',
        fullName: '',
        email: '',
        phone: ''
    };

    constructor(
        private customermodelservice: Customerservice,
        private cdr: ChangeDetectorRef
    ) { }

    ngOnInit(): void {

        console.log("INIT CALLED");

        this.getAllCustomers();
    }

    getAllCustomers() {

        this.customermodelservice.getAllCustomermodels().subscribe({

            next: (customers) => {

                this.customers = customers;

                console.log(this.customers);

                this.cdr.detectChanges();
            },

            error: (error) => {

                console.log("Error while fetching customers", error);
            }
        });
    }

    addCustomer() {

        console.log(this.customer);

        this.customermodelservice.createCustomermodel(this.customer).subscribe({

          next: (response) => {

                console.log("Customer added successfully", response);

                this.customer = {

                    customerType: '',
                    fullName: '',
                    email: '',
                    phone: ''
                };

                this.getAllCustomers();
            },

            error: (error) => {

                console.log("Error while adding customer", error);
            }
        });
    }

    editCustomer(id: any) {

        this.customermodelservice.getCustomermodelById(id).subscribe({

            next: (customer) => {

                this.customer = customer;
            },

            error: (error) => {

                console.log("Error while fetching customer", error);
            }
        });
    }

    deleteCustomer(id: any) {

        this.customermodelservice.deleteCustomermodel(id).subscribe({

            next: () => {

                console.log("Customer deleted successfully");

                this.getAllCustomers();
            },

            error: (error) => {

                console.log("Error while deleting customer", error);
            }
        });
    }
}