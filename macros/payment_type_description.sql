{# Maps the TLC payment_type code to a readable label. First custom macro: Jinja + SQL. #}
{% macro payment_type_description(column_name) %}
    case {{ column_name }}
        when 0 then 'flex_fare'
        when 1 then 'credit_card'
        when 2 then 'cash'
        when 3 then 'no_charge'
        when 4 then 'dispute'
        when 5 then 'unknown'
        when 6 then 'voided'
        else 'other'
    end
{% endmacro %}
