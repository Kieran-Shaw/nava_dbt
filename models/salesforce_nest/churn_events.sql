/*
This .sql model materializes a churn_events table
This table will make sure that we have correct and updated churn information in brokerage ops
if it is entered into salesforce first
*/

{{ config(materialized="table") }}

with clients as (
    
    select
        sfdc_id,
        account_name
    from
        {{ ref('clients') }}
    where
        account_type = 'Churned'

),

churned_clients as (

    select
        clients.sfdc_id,
        clients.account_name,
        acc.churn_notification_date__c as churn_notification_date,
        acc.churn_date__c as churn_effective_date,
        acc.churn_reason__c as churn_reason,
        acc.churn_notes__c as churn_notes
    from clients
        join salesforce.Account as acc on acc.id = clients.sfdc_id
)

select *
from churned_clients
order by account_name asc