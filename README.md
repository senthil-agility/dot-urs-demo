# DOT FMCSA URS Demo

## Use Case Name
Create and make changes to an official FMCSA registration record.

## Subject Area
Motor Carrier, Broker, Freight Forwarder, Insurance Company, Process Agent

## Business Event
Customer provides log-in information and multi-factor authentication at the URS interface point to access their record.

## Actors
Customer who is the legally responsible authority to add, change and view a registration record (authorizing official).

## Use Case Overview
Customer’s first need to create a secure account and validate existing Agency historical data on file (if applicable) to create their profile. Then, the Customer can create a new registration, make changes to an existing registration and view the status of their record and any supporting documents in its entirety from a profile interface.

## Preconditions
Customers provide key identification information in their profile to ensure that URS assigns them to the right workflow. Required information can be found within FMCSA registration standard forms and in instructions found on the FMCSA website. Each Customer type (see “Actor” above) is required to follow a specific regulation where some, but not all requirements apply to each Customer. Therefore, separate workflows are needed for each Customer type to ensure all applicable regulatory requirements are met. See URS business requirements document for the explanations of the Customer types and different workflows required.

Edit-checks and smart-logic functions are required to ensure data entered is accurate and in accordance with regulatory requirements. For example, a P.O. Box is not a regulatory permissible place of business for a motor carrier. Instead, the address must be a physical location where business records are kept. Also, addresses entered by the customer must be valid USPS addresses and customers may not key in invalid characters or unavailable numbers (e.g., 999-999-9999).

Upon the Customer saving a profile or completing a new or change in registration, the record data shall pass an electronic safety algorithm check to detect if the entity’s information is associated with any other record in FMCSA’s database. This check may also include checks with databases/information outside FMCSA’s environment. If so, the Customer would be presented with an alert with directions on how to address the message. See URS business requirements document (section re: Utility for Risk-Based Screening and Assessment [URSA]) for additional information.

## Termination Outcome
Customer receives confirmation screen that their profile is up-to-date or that their request for new or updated registration has been submitted for processing, with a confirmation screen when they should expect to hear back from FMCSA, any applicable next steps and instructions to withdraw or change the request if necessary.
Additional Checks:
- Multiple exchanges with pay.gov must occur to ensure the credit card transaction is not cancelled while the service/authority is still provided. Pay.gov records must also automatically reconcile with FMCSA transactions, matching payments with FMCSA records.
- Smart logic and edit checks must be embedded throughout to detect large disparities between power units and drivers to ensure accurate and valid data is being entered (e.g., 1 driver versus 999 power units.
- Smart logic that takes a definition of an authority type or entity type to determine the accurate registration process an applicant would follow (e.g., applying as Freight Forwarder when really a Property carrier or applying as an Intermodal Equipment Provider (IEP) when really not an IEP).
- Smart logic that will determine if the applicant is required to enter the New Entrant Program based on if the company operates commercial motor vehicles (CMVs).
- Smart logic that knows what insurance amount is required based on the authority type (e.g., a Property carrier requires $300,000 or $750,000).
- Smart logic that prevents Mexican citizens from applying for Enterprise Authority when their principal place of business is not located in the United States.
- The system must easily exchange information with downstream State systems.
- The system must be permissions role based, allowing certain FMCSA users to edit any field within any record.
- The system should pre-populate any previously entered information provided by the applicant when they return to complete an update.
- The system should record and log every addition, change, and edit made to any record and identify who made the addition, change, or edit.
- Allow role-based permissions that make it easy to change any FMCSA generated letter.
- Generate notices related to the USDOT number, as appropriate.
- Generate notices related to operating authority, as appropriate, based on the insurance and BOC-3 requirements being met.

## Condition affecting termination outcome
Invalid data (e.g., misspelling, invalid area code, unknown address).

## Use Case Description
The Customer shall access the MCSA-1 form via URS to make its initial submission or to make updates to its registration. User can navigate the applicable sections of the form and submit the applicable registration fee. The customer shall be prompted by URS to correct an error/inaccuracy/flag in their profile prior to making any other changes to their record. They shall be able to save their record (even with the inaccuracies) and return later to correct, but not permitted to proceed to make any other record changes.

## Output Summary
Customer profile (includes USDOT number and type of authority), summary page confirming a new or updated registration, copies of FMCSA letters mailed to the entity and any supporting documentation provided by the Customer shall be available in the system.
