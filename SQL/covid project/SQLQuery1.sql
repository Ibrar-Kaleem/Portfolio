

select *
from CovidDeath
where continent is not null
order by 1,2

select *
from CovidVaccinated

-- Select dat that we are going to use 

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeath
where continent is not null
order by 1,2


select location,date,total_cases,total_deaths, (total_deaths*1.00)/(total_cases)*100 deathpercentage
from CovidDeath
where location like '%pakis%' and continent is not null

order by 1,2;


-- totalcases vs population

select location,date,total_cases,population, (total_cases *1.00)/(population)*100 casesvspopulation
from CovidDeath
where location = 'Pakistan' and continent is not null
order by 1,2;


-- looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as HighestInfectionCount, ((max(total_cases)*1.00)/(population)*100) as percentagePopulationInfectioed
from CovidDeath
where continent is not null
group by location,population
order by percentagePopulationInfectioed desc
-- 


--Showing Countries with highest death count per population

select location, max(total_deaths) as totaldeathcount
from CovidDeath
where continent is not null
group by location
order by totaldeathcount desc

-- Let' Break things down by continent
-- showing the continents with highest death count


select location, max(total_deaths) as totaldeathcount
from CovidDeath
where continent is null and location not like '%income%' and location <> 'World' and location <> 'European Union'
group by location
order by totaldeathcount desc


-- Global Numbers

select date, sum(new_cases) as sumofnewcases, sum(new_deaths) as sumofnewdeaths,(nullif(sum(new_deaths),0)*1.00)/ nullif(sum(new_cases),0)*100 as DeathPercentages
from CovidDeath
where continent is not null
group by date
order by 1,2


select sum(new_cases) as Total_cases,sum(new_deaths) as Total_death, sum(new_deaths)*1.00*100/sum(new_cases) as deathpercent
from CovidDeath

Select * from CovidVaccinated


select *
from CovidVaccinated as cv
inner join CovidDeath as cd on cv.location=cd.location and cv.date=cd.date

-- Looking at Total Population vs vaccination

select cd.location,cd.population, sum(new_vaccinations) as newlyvaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
group by cd.location,cd.population
order by 2 desc

--
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null and cd.location = 'Canada'
order by 2,3

--Rolling count


select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, sum(cv.new_vaccinations) Over (partition by cv.location order by cv.date) as Rollingpeoplevaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
order by 2,3

-- USE CTE

with popvsvac as (
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, sum(cv.new_vaccinations) Over (partition by cv.location order by cv.location,cv.location) as Rollingpeoplevaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--Order by location desc
)

select *, (Rollingpeoplevaccinated*100.00/population)
from popvsvac
order by 2


--Temp table


Create Table #percentpopulationVacinnated
(
Continent nvarchar(255),
Location nvarchar(255),
Date date,
population int,
New_vaccination int,
RollingPeopleVaccinated float
)

Insert into #percentpopulationVacinnated
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, sum(cv.new_vaccinations) Over (partition by cv.location order by cv.location,cv.location) as Rollingpeoplevaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--Order by location desc

select *, (Rollingpeoplevaccinated*100.00/population) as RollingPeopleVaccinated
from #percentpopulationVacinnated
order by 2

Select * from #percentpopulationVacinnated


-- test for temp table




Drop Table #percentpopulationVacinnated2
Create Table #percentpopulationVacinnated2
(
Continent nvarchar(255),
Location nvarchar(255),
Date date,
population int,
New_vaccination int,
Rollingpeoplevaccinated bigint,
asd float
)

With CTE2 as(
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, sum(cv.new_vaccinations) Over (partition by cv.location order by cv.location,cv.location) as Rollingpeoplevaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--Order by location desc
)

Insert into #percentpopulationVacinnated2
select *,(Rollingpeoplevaccinated*100.00/population)
from CTE2

Select * from #percentpopulationVacinnated2


-- Create View to store data 

Create View PercentPopulationVaccinated as
with popvsvac as (
select cd.continent,cd.location,cd.date, cd.population,cv.new_vaccinations, sum(cv.new_vaccinations) Over (partition by cv.location order by cv.location,cv.location) as Rollingpeoplevaccinated
From CovidVaccinated as cv
inner join CovidDeath cd on cv.location=cd.location and cv.date=cd.date
where cd.continent is not null
--Order by location desc
)

select *, (Rollingpeoplevaccinated*100.00/population) as PPV
from popvsvac

Select * from PercentPopulationVaccinated
















