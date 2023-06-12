global class JITUserProvisioningHandler implements Auth.SamlJitHandler {
    private class JitException extends Exception{}
    
    /* SAML Attribute Names */
    private static final String ATTR_EMAIL = 'email';
    
    /* User Attribute Names */
    private static final String USER_FIRST_NAME = 'FirstName';
    private static final String USER_LAST_NAME = 'LastName';
    private static final String USER_EMAIL = 'Email';
    private static final String USER_USERNAME = 'Username';
    private static final String USER_ALIAS = 'Alias';
    
    /* Community Attributes */
    private static final String TBD = 'TBD';
    private static final String ACCOUNT_NAME = 'Portal Account';
    private static final String COMMUNITY_USERNAME_SUFFIX = '@fmscaportal.community';
    public static final String COMMUNITY_PROFILE_NAME = 'FMSCA Community Plus Login User';
    
    /* User Attributes Max Size */   
    private static final Map<String, Integer> USER_ATTR_SIZE_MAP = new Map<String, Integer> {
        USER_FIRST_NAME => 40,
        USER_LAST_NAME => 80,
        USER_EMAIL => 128,
        USER_USERNAME => 80,
        USER_ALIAS => 8            
    };
                
    // ====================== GLOBAL METHODS CALLED BY SALESFORCE SAML PROCESS ====================== //
        
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
            
        // we are here because salesforce couldn't find a user matching the federationId 
        User u = new User();
        handleUser(true, u, attributes, federationIdentifier);
            
        return u;
    }
    
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {               
        //not implemented
    }
    
    // ====================== PRIVATE METHODS ====================== //
    
    private void handleUser(boolean create, User u, Map<String, String> attributes, String federationIdentifier) {
        
        if (create) {            
            u.IsActive = true; 
            
            u.FederationIdentifier = federationIdentifier;
            System.debug('============> FederationId set to ' + u.FederationIdentifier);            
            
            u.LastName = TBD;
            System.debug('============> LastName set to ' + u.LastName);            
            
            u.Email = attributes.get(ATTR_EMAIL);
            System.debug('============> Email set to ' + u.Email);
            
            u.Username = deriveUsernameFromEmail(u.Email);  
            System.debug('============> Username set to ' + u.Username);
            
            u.Alias = deriveAliasFromEmail(u.Email);
            System.debug('============> Alias set to ' + u.Alias);
            
            String profileId = [SELECT Id FROM Profile WHERE Name =: COMMUNITY_PROFILE_NAME Limit 1].Id;
            u.ProfileId = profileId;
            System.debug('============> ProfileId set to ' + u.ProfileId);
            
            String uid = UserInfo.getUserId();
            User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id =: uid];
            
            u.LocaleSidKey = currentUser.LocaleSidKey;
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
            
            u.ContactId = findOrCreateContact(attributes); 
            
            System.debug('======> Creating New User: ' + u.Username);
            
        } else {
            System.debug('======> No updates to User record');
        }
    }
    
    private Id findOrCreateContact(Map<String, String> attributes) {
        Contact c = null;
        
        try {
            if (attributes.containsKey(ATTR_EMAIL) && (attributes.get(ATTR_EMAIL) != null) && (attributes.get(ATTR_EMAIL) != '')) {
                String email = attributes.get(ATTR_EMAIL);
                c = [Select Id, AccountId From Contact where Email = :email Limit 1];
                
                System.debug('======> Found Matching Contact: ' + c.Id);
            }
        } catch (Exception e) {
            // ignore - move on to create account and contact
        }
        
        if (c == null) { 
            System.debug('======> Creating new Account and Contact');
            
            Account acct = createAccount(attributes);
            c = createContact(acct, attributes);            
        }
        
        return c.Id;
    }
    
    private Account createAccount(Map<String, String> attributes) {
        Account acct = null;
        String acctName = ACCOUNT_NAME;
        
        try {
            acct = [Select Id, Name From Account Where Name = :acctName Limit 1];
            System.debug('=========> Found Account: ' + acct);                
        } catch (Exception ex) {
            /* ignore */
        }
        
        if (acct == null) {
            acct = new Account(Name = acctName);
            insert acct;
            
            System.debug('=========> Created Account: ' + acct);            
        }        
        
        return acct;
    }
    
    private Contact createContact(Account acct, Map<String, String> attributes) {                                                 
        Contact c = new Contact();       
        
        c.AccountId = acct.Id;
        c.FirstName = TBD;
        c.LastName = TBD;        
        c.Email = attributes.get(ATTR_EMAIL);        
        
        insert c;
        
        System.debug('=========> Created Contact: ' + c.Id);
        
        return c;
    }
    
    private String deriveUsernameFromEmail(String email) {
        String username = email.substring(0, email.indexOf('@'));
        String randomizer = String.valueOf(Integer.valueOf(Math.random()*1000000));
        Integer maxLength = USER_ATTR_SIZE_MAP.get(USER_USERNAME);
        Integer prefixLength = maxLength - randomizer.length() - COMMUNITY_USERNAME_SUFFIX.length();
        
        if (username.length() > prefixLength) {
            username = username.substring(0, prefixLength);
        }
        
        return (username + randomizer + COMMUNITY_USERNAME_SUFFIX);                 
    }
    
    private String deriveAliasFromEmail(String email) {
        String alias = email.substring(0, email.indexOf('@'));
        
        String randomizer = String.valueOf(Integer.valueOf(Math.random()*10000));        
        Integer maxLength = USER_ATTR_SIZE_MAP.get(USER_ALIAS);
        Integer prefixLength = maxLength - randomizer.length();
        
        if (alias.length() > prefixLength) {
            alias = alias.substring(0, prefixLength);
        }
        
        return (alias + randomizer);        
    }      
}