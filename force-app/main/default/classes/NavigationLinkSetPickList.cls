// False positive PMD warning
// 'global' modifier is required to override inherited global methods from VisualEditor.DynamicPickList
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class NavigationLinkSetPickList extends VisualEditor.DynamicPickList {
    global override VisualEditor.DataRow getDefaultValue() {
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(
            'Default Navigation',
            'Default Navigation'
        );
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows picklistValues = new VisualEditor.DynamicPickListRows();
        // False positive PMD warning - still unable to detect 'WITH [access_modifier]' in SOQL queries
        @SuppressWarnings('PMD.ApexCRUDViolation') 
        List<NavigationLinkSet> navigationLinkSetList = [
            SELECT MasterLabel, DeveloperName
            FROM NavigationLinkSet
            WITH USER_MODE
        ];
        for (NavigationLinkSet navigationLinkSet : navigationLinkSetList) {
            VisualEditor.DataRow value = new VisualEditor.DataRow(
                navigationLinkSet.MasterLabel,
                navigationLinkSet.DeveloperName
            );
            picklistValues.addRow(value);
        }
        return picklistValues;
    }
}
