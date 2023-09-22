/*
This .sql model materializes a clients table
This clients table is important for maintaining an accurate client list in NEST.
The primary key is the salesforce_id, as each client will have a salesforce_id
*/

{{ config(materialized="table") }}

with current_and_churned_clients as (
    select 
        id as sfdc_id,
        name as account_name, 
        type as account_type,
        sic_code__c as sic_code,
        dba_name_incorporated_name__c as legal_name,
        REPLACE(
            REGEXP_REPLACE(ein__c, '[^0-9]', ''),
            '-',
            ''
        ) as cleansed_tax_id,
        total_closed_arr__c as total_closed_annual_revenue
    from salesforce.Account
    where type IN ('Customer','Churned')
),

clean_clients_information as (
    select
    sfdc_id,
    account_name,
    account_type,
    sic_code,
    legal_name,
    CASE 
        WHEN LENGTH(cleansed_tax_id) = 9 THEN 
            CONCAT(SUBSTR(cleansed_tax_id, 1, 2), '-', SUBSTR(cleansed_tax_id, 3))
        ELSE 
            NULL
    END as ein_number,
    total_closed_annual_revenue
    from current_and_churned_clients
    order by account_type desc, account_name asc, sfdc_id

)

select *
from clean_clients_information