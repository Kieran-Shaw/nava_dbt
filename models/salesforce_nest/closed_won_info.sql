/*
This .sql model materializes a closed_won table
This closed_won table is important for maintaining accurate and updated closed_won information
The primary key is the client_id, each client with have a unique primary key
*/       

{{ config(materialized="table") }}

with clients as (

    select
        sfdc_id, 
        account_name
    from 
        {{ ref('clients') }}

),

opportunity_filtered_closed_won as (

    select
        clients.sfdc_id as client_sfdc_id,
        opp.id as opp_sfdc_id,
        clients.account_name,
        opp.name as opp_name,
        opp.closedate as close_date,
        opp.bor_date__c as final_bor_date,
        opp.bor_date_sales_estimate__c as sales_estimate_bor_date,
        opp.bor_date_finance_update__c as finance_update_bor_date,
        opp.renewal_date__c as renewal_date,
        opp.type as opportunity_type
    from clients
        join salesforce.Opportunity as opp on opp.accountid = clients.sfdc_id
    where
        renewal__c is false
        and closedate is not null
        and isclosed is true

)

select *
from opportunity_filtered_closed_won
order by account_name asc, opp_name asc