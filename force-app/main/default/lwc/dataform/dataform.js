import { LightningElement, api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';

export default class Dataform extends LightningElement {
    @api recordId;
    accountObject = ACCOUNT_OBJECT;
    myFields = [NAME_FIELD, WEBSITE_FIELD];
    nameField = NAME_FIELD;
    websiteField = WEBSITE_FIELD;

    handleSubmit() {
        // Code that runs when form is submitted.
    }

    handleAccountCreated(){
        // Run code when account is created.
    }
}