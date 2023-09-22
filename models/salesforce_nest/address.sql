/*
This .sql model materializes an addresses table
We are bringing in both the billing and the shipping address
*/

{{ config(materialized="table") }}

with clients as (
    
    select
        sfdc_id,
        account_name
    from
        {{ ref('clients') }}
    where
        account_type = 'Customer'

),

accounts_addresses as (

    select
        clients.sfdc_id as client_sfdc_id,
        clients.account_name,
        json_extract_scalar(acc.billingaddress, '$.street') as billing_address_street,
        json_extract_scalar(acc.billingaddress, '$.city') as billing_address_city,
        json_extract_scalar(acc.billingaddress, '$.state') as billing_address_state,
        json_extract_scalar(acc.billingaddress, '$.postalCode') as billing_address_zip_code
    from clients
        join salesforce.Account as acc on acc.id = clients.sfdc_id

)

select

    *,
    concat(
        billing_address_street,
        ', ',
        billing_address_city,
        ', ',
        billing_address_state,
        ' ',
        billing_address_zip_code
    ) as full_billing_address

from accounts_addresses
