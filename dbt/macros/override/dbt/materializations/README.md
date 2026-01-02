# Contents #
1. General Notes
2. Macro Specific Notes
    - null_safe_delete_insert


## General Notes ##
Macros in this folder alter the behavior of the defualt materializations used by DBT. They should only be incorporated into a project when they are appropriate rather than by default.


## Macro Specific Notes ##

### null_safe_delete_insert ###
DBT for fabric does not support 'merge' type incremental materializations. The supported model of 'delete+insert' only deletes exact matches, and does not delete rows if one of the specified primary keys is NULL. However some data streams do contain NULL in key fields, such as digital activity that reports a NULL session id for a failed login. While this is a corner case, this macro adds a check for both key values being null. It converts the template from 
> {{ source }}.{{ key }} = {{ target }}.{{ key }}
to 
> ({{ source }}.{{ key }} = {{ target }}.{{ key }} or ({{ source }}.{{ key }} is NULL and  {{ target }}.{{ key }} is NULL))
It adds enclosing parenthesis around the line and adds an or clause after the equality statement to see if both keys are null. At the time of writting, there is no null-safe equality function available in fabric that could have been used instead.