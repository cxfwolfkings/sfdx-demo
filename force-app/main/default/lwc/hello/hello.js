import { LightningElement, api } from 'lwc';

export default class Hello extends LightningElement {
    @api name;
    // Always set the default value for a boolean to false
    @api show = false;
    @api privateTitle;

    connectedCallback() {
        const tabindex = this.getAttribute('tabindex');
    
        // Set the tabindex to 0 if it hasn't been set by the consumer.
        if (!tabindex) {
            this.setAttribute('tabindex','0');
        }
    }

    /**
     * 将js的properties映射到html的attributes
     */
    @api
    get title() {
        return this.privateTitle;
    }

    set title(value) {
        this.privateTitle = value.toUpperCase();
        this.setAttribute('title', this.privateTitle);
    }

    handleChangeName(event) {
        this.name = event.target.value;
    }
}