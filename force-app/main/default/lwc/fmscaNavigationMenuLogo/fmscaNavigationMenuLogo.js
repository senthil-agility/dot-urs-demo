import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import DOT_LOGO from '@salesforce/resourceUrl/fmscaLogo';


export default class FmscaNavigationMenuLogo extends NavigationMixin(LightningElement) {
    @api formfactor;
    @api page;

    get logo() {
        return DOT_LOGO;
    }

    handleClick(evt) {
        // use the NavigationMixin from lightning/navigation to perform the navigation.
        // prevent default anchor link since lightning navigation will be handling the click
        evt.stopPropagation();
        evt.preventDefault();
        // Navigate to the home page
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            }
        });
    }
}