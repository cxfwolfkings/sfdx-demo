import { LightningElement, api, track } from 'lwc';

export default class Hello extends LightningElement {
    @api name;
    @track firstName = '';
    @track lastName = '';

    handleChangeName(event) {
        this.name = event.target.value;
    }

    handleChangeFullName(event) {
        const field = event.target.name;
        if (field === "firstName") {
            this.firstName = event.target.value;
        } else if (field === "lastName"){
            this.lastName = event.target.value;
        }
    }

    get uppercasedFullName() {
        return `${this.firstName} ${this.lastName}`.toUpperCase();
    }

}