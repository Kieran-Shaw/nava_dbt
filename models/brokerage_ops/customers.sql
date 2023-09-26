/* active clients model */

{{ config(materialized="view",sort="name") }}

with active_clients as (

    select
        "Id" as sfdc_id,
        "Name" as name,
        case
            when "Type" = 'Customer' then true
            else false
        end as is_customer,
        dba_name_incorporated_name__c as legal_name,
        case 
            when nbg_bor__c is null then 'Nava' 
            else 'NBG' 
        end as customer_company,
        naics__c as naics_code,
        sic_code__c as sic_code,
        case 
            when "Type" = 'Customer' then total_closed_arr__c
            else null
        end as total_closed_arr,
        lastactivitydate as last_activity_date

    from
        airbyte_data.account
    
    where
        "Type" in ('Customer','Churned')
        and isdeleted is false
)

select *
from active_clients