/* active clients model */

{{ config(materialized="view") }}

with active_clients as (

    select
        "Id" as sfdc_id,
        "Name" as account_name

    from
        airbyte_data.account
    
    where
        "Type" = 'Customer'
)

select *
from active_clients