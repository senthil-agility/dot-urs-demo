import { LightningElement, wire, api } from 'lwc';
import fetchApplicationData from '@salesforce/apex/FmscaPortalController.fetchApplicationData';
// import fetchApplicationData from '@salesforce/apex/FmscaPortalController.fetchCaseData';
import { NavigationMixin } from 'lightning/navigation';

export default class CaseDashboard extends LightningElement {
    @api appData = [];

    connectedCallback() {
        console.log('connectedCallback');
        fetchApplicationData()
            .then(result => {
                this.appData = result;
            })
    }

    handleClick(e) {
        // console.log('test');
    }

    get hasData() {
        return this.appData && this.appData.length > 0;
    }

    get emptyList() {
        return !this.hasData;
    }
}