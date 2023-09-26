/* churned clients model */

{{ config(materialized="view") }}

with churned_clients as (

    select
        "Id" as sfdc_id,
        "Name" as account_name

    from
        airbyte_data.account
    
    where
        "Type" = 'Churned'
)

select *
from churned_clients