/*
    disney stock analysis queries
    description: these sql queries provide insights into disney's stock performance, including trends over time, volatility, price movements, and volume correlations. this dataset spans from 1962 to august 2024. the queries are useful for major stakeholders, aspiring investors, and stock traders.
*/

-- 1. average stock prices, highs, and lows by decade
-- purpose: help major stakeholders understand long-term stock performance over the decades.

select 
    case 
        when `date` between '1962-01-01' and '1969-12-31' then '1960s'
        when `date` between '1970-01-01' and '1979-12-31' then '1970s'
        when `date` between '1980-01-01' and '1989-12-31' then '1980s'
        when `date` between '1990-01-01' and '1999-12-31' then '1990s'
        when `date` between '2000-01-01' and '2009-12-31' then '2000s'
        when `date` between '2010-01-01' and '2019-12-31' then '2010s'
        when `date` between '2020-01-01' and '2024-12-31' then '2020s'
        else 'unknown'
    end as decade,
    avg(`close`) as avg_close_price,
    max(`high`) as max_high_price,
    min(`low`) as min_low_price
from 
    dis
group by 
    decade;

-- 2. yearly volatility (percentage change in closing prices)
-- purpose: give aspiring investors an idea of how volatile disney's stock has been year-over-year.

select 
    year(`date`) as year,
    (max(`close`) - min(`close`)) / min(`close`) * 100 as yearly_volatility
from 
    dis
group by 
    year
order by 
    year asc;

-- 3. top 10 days with highest price increase
-- purpose: help stock traders identify the best trading days for disney stocks.

select 
    `date`, 
    `close`, 
    (`close` - `open`) as price_change, 
    ((`close` - `open`) / `open`) * 100 as percentage_change
from 
    dis
order by 
    percentage_change desc
limit 10;

-- 4. average daily trading volume per year
-- purpose: show how disney's stock volume has trended, useful for both investors and traders.

select 
    year(`date`) as year, 
    avg(`volume`) as avg_daily_volume
from 
    dis
group by 
    year
order by 
    year asc;

-- 5. correlation between closing prices and volume per year
-- purpose: provide insights into how price and volume trends have interacted over time.

select 
    year(`date`) as year,
    corr(`close`, `volume`) as price_volume_correlation
from 
    dis
group by 
    year;

-- 6. moving average analysis of closing prices
-- purpose: for traders and investors to assess trends based on moving averages.

select 
    `date`,
    avg(`close`) over (order by `date` rows between 29 preceding and current row) as moving_avg_30,
    avg(`close`) over (order by `date` rows between 59 preceding and current row) as moving_avg_60,
    avg(`close`) over (order by `date` rows between 119 preceding and current row) as moving_avg_120
from 
    dis;

-- 7. largest price drops in a single day
-- purpose: show traders which days had the biggest price drops, helping with risk management.

select 
    `date`, 
    (`open` - `close`) as price_drop, 
    ((`open` - `close`) / `open`) * 100 as percentage_drop
from 
    dis
order by 
    percentage_drop desc
limit 10;
