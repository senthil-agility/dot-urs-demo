import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CaseList extends NavigationMixin(LightningElement) {
    _formData;
    @api showDetail = false;
    
    @api
    get formData() {
        return this._formData && this._formData.caseData;
    }
    set formData(data) {
        this._formData = data;
    }

    get caseId() {
        return this.formData && this.formData.Id;
    }

    get sesh() {
        return this._formData && this._formData.sesh;
    }

    get formStatus() {
        return this.formData && this.formData.Status;
    }

    get formStatusDisplay() {
        return '';
    }

    get formName() {
        return this.formData && this.formData.CaseNumber;
    }

    get applicantName() {
        return this.formData && this.formData.Owner.Name;
    }
    // return this.formData && this.formData.New_Entrant__c;
    get buttonClass() {
        return;
    }
    get iconType() {
        // return 'utility:forward';
        if (this.formStatus === 'New') {
            return 'utility:forward';
        } else if (this.formStatus === 'Submitted') {
            return this.expandIcon;
        }
    }

    get renderButtonIcon() {
        // return true;
        return this.formStatus === 'New';
    }
    get renderIcon() {
        // return !this.renderButtonIcon;
        return false;
    }

    get iconSize() {
        if (this.renderButtonIcon) {
            return 'small';
        }
        return 'x-small';
    }

    get expandIcon() {
        if (this.showDetail) {
            return 'utility:chevrondown';
        }
        return 'utility:chevronright';
    }
 
    handleExpandDetails(e) {
        this.showDetail = !this.showDetail;
    }
    handleOmniNav(e) {
        const shtate = {
            c__target: 'c:caseCaseEnglish',
            c__layout: 'lightning',
            c__tabIcon: 'custom:custom18',
            c__tabLabel: 'FMCSA Application',
            c__ContextId: this.formData.Id || ''
        };
        if (this.sesh && this.sesh.Id) {
            shtate.c__sfl = true;
            shtate.c__instanceId = this.sesh.Id;
        }
        if (this.formStatus === 'New' || this.formStatus === 'Draft') {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'Omni_Test__c'
                },
                state: {
                    ...shtate
                }
            });
        }
    }
}