select * 
from PortfolioProject..covidDeath
order by 3, 4

--select * 
--from PortfolioProject..covidvaccination
--order by 3, 4

-- selecting the used data for this project 

select location , date , total_cases, new_cases, total_deaths, d.population
from PortfolioProject..covidDeath as d
order by 1,2
 
 -- total cases vs total death
 -- shows the likelihood die from covid pandamic

select location , date , total_cases,total_deaths , (total_deaths/ total_cases)*100 as total_presentage
from PortfolioProject..covidDeath as d
where location like '%states%'
order by 1,2

  --looking at the total cases vs popultation
  select location , date , total_cases,total_deaths, d.population , (total_deaths/ d.population)*100 as populationinfec
from PortfolioProject..covidDeath as d
where location like '%states%'
order by 1,2

-- looking at the hightest infection rate

  select location , max(total_cases) as highestInfectionCount  , max( total_cases  / population)*100 as populationinfec
from PortfolioProject..covidDeath 
Group by location, population
order by populationinfec desc

-- Showing countries with the hightest Death Count per population 
 select location, max(total_deaths/ population) as hightestDeathCount
from PortfolioProject..covidDeath 
Group by location
order by hightestDeathCount desc
 
select location, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..covidDeath
where continent is not null
group by location
order by totalDeathCount desc

select continent, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..covidDeath
where continent is not null
group by continent
order by totalDeathCount desc

-- getting global numbers
select date, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..covidDeath
where continent is not null
group by date
order by totalDeathCount desc

select sum(cast(new_cases as int)) TotalNewCases , sum(cast(new_deaths as int)) TotalNewDeath, (sum(cast(new_deaths as int))/ sum(cast(new_cases as int)) )*100 as DeathPresentage
from PortfolioProject..covidDeath
where continent is not null
group by date
order by  1, 2


-- useing cte
with popvsVac( continent , location, Date, population, new_vaccination , RollingPeopleVaccinated)
as (
select d.location , d.date , d.continent , d.population,v.new_vaccinations, sum(convert( int, v.new_vaccinations)) over (partition by d.location order by d.location) as RollingPeopleVaccinated
from PortfolioProject..covidDeath  d  
join PortfolioProject..covidvaccination v 
     on d.location = v.location and d.date = v.date 
where d.continent is not null 
)

select * , (RollingPeopleVaccinated/ population) as totalPopulitionVaccination
from popvsVac

-- creating table

create table #presentangePopulationVaccinated (
continent nvarchar(225),
location nvarchar(225), 
population numeric , 
date datetime, 
new_vaccianted numeric, 
RollingPeopleVaccinated numeric 
)

insert into #presentangePopulationVaccinated 
select d.location , d.date , d.continent , d.population,v.new_vaccinations, sum(convert( int, v.new_vaccinations)) over (partition by d.location order by d.location) as RollingPeopleVaccinated
from PortfolioProject..covidDeath  d  
join PortfolioProject..covidvaccination v 
     on d.location = v.location and d.date = v.date 
where d.continent is not null 


Drop Table if exists #presentangePopulationVaccinated


-- 