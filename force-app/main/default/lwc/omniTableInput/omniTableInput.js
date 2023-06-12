import { LightningElement, api, wire, track } from 'lwc';
import { OmniscriptBaseMixin } from "omnistudio/omniscriptBaseMixin";

const TABLE_ROWS = [
    {title: 'Straight Truck(s)', fields: ['Straight_Trucks_Owned__c','Straight_Trucks_Term_Leased__c','Straight_Trucks_Trip_Leased__c','Straight_Trucks_Tow_Driveway__c','blankspace']},
    {title: 'Truck Tractor(s)', fields: ['Truck_Tractors_Owned__c','Truck_Tractors_Term_Leased__c','Truck_Tractors_Trip_Leased__c','Truck_Tractors_Tow_Driveway__c','blankspace']},
    {title: 'Trailer(s)', fields: ['Trailers_Owned__c','Trailers_Term_Leased__c','Trailers_Trip_Leased__c','Trailers_Tow_Driveway__c','blankspace']},
    {title: 'IEP Trailer Chassis Only', fields: ['IEP_Trailer_Chassis_Owned__c','IEP_Trailer_Chassis_Term_Leased__c','IEP_Trailer_Chassis_Trip_Leased__c','IEP_Trailer_Chassis_Tow_Driveway__c','IEP_Trailer_Chassis_Serviced__c']}
];
const TABLE_HEADERS = ['Type', 'Owned', 'Term Leased', 'Trip Leased', 'Tow/Driveway', 'Serviced'];

export default class OmniTableInput extends OmniscriptBaseMixin(LightningElement) {
    caseId;

    @api
    get caseid() {
        return this.caseId;
    }
    set caseid(value) {
        this.caseId = value;
    }
    get tableRows() {
        return TABLE_ROWS;
    }

    get tableHeaders() {
        return TABLE_HEADERS;
    }

    handleFieldChange(e) {
        
    }

    generateKey() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(
            /[xy]/g,
            function (c) {
                var r = (Math.random() * 16) | 0,
                    v = c === 'x' ? r : (r & 0x3) | 0x8;
                return v.toString(16);
            }
        );
    }
}