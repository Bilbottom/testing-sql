Customer Database
---

### Tables
* `balance_history`
* `customer_relationships`
* `customers`
* `loans`


### Table Details

#### Balance History

The `balance_history` table is a "delta"/"incremental" table. This means that when the balance on a loan changes, the new balance will be appended to this table

This allows us to track the history of balances in an efficient way. You "fill in the gaps" by using the latest report per gap

For example, take the loan with the ID of `LOA123046`:
* This loan had a balance of £26,000 on 2020-01-05
* The next change in balance for this loan was on 2020-01-12 where it dropped to £25,957.47 -- this means that the balance for this loan remained at £26,000 for every day until 2020-01-12
* The next few changes in balance for this loan were on 2020-01-16, 2020-01-17, and 2020-02-29 where it dropped to £25,799.47, then £25,359.23 and then £24,678.09
* This means that the balance for this loan at the 2020-01 month-end was £25,359.23
