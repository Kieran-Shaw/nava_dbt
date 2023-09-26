/* churned clients model */

{{ config(materialized="view", sort="name") }}

with churned_clients as (

    select
        "Id" as sfdc_id,
        "Name" as name,
        total_closed_arr__c as churn_total_closed_arr,
        churn_reason__c as churn_reason,
        churn_date__c as churn_date,
        churn_notes__c as churn_notes,
        churn_notification_date__c as churn_notification_date,
        lastactivitydate as sfdc_last_modified_date
        
    from
        airbyte_data.account
    
    where
        "Type" = 'Churned'
)

select *
from churned_clients