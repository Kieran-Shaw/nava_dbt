/*
This .sql model materializes a finance_renewals table
This table is important for maintaining accurate and updated finance renewal structure for reporting
The primary key is the opp_id, each client with have a unique primary key
*/

{{ config(materialized="table") }}

with clients as (

    select
        sfdc_id, 
        account_name
    from 
        {{ ref('clients') }}

),
all_opportunities_joined as (

    select
        opp.id as opp_sdc_id,
        opp.name as opp_name,
        clients.sfdc_id,
        clients.account_name,
        opp.closedate as close_date,
        opp.isclosed as is_closed,
        opp.finance_arr__c as finance_annual_revenue,
        opp.estimated_expected_commissions_total__c as estimated_expected_commissions_total,
        opp.enrolled_medical_lives__c as num_enrolled_medical_lives,
        opp.renewal__c as is_renewal
    from
        clients
        join salesforce.Opportunity as opp on opp.accountid = clients.sfdc_id

)

select *
from all_opportunities_joined