SELECT *
FROM [Portfolio project]..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3,4


-- Select Data that we are going to be starting with
SELECT location, date, population,total_cases, new_cases, total_deaths
FROM [Portfolio project]..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2

--- Total Cases vs Total Deaths( What is the likelihood of dying if you contract covid in the US)

SELECT location, date, total_cases,  total_deaths, ROUND((total_deaths/total_cases)*100,2) As death_percentage
FROM [Portfolio project]..CovidDeaths
WHERE continent is NOT NULL AND location Like '%states%'
ORDER BY death_percentage DESC

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  ROUND((total_cases/population)*100,2) as Percent_Population_Infected
From [Portfolio project]..CovidDeaths
order by 1,2

----Highest death count in the US
SELECT location, date, Max(CAST (new_deaths AS INT))AS Max_deaths
FROM [Portfolio project]..CovidDeaths
WHERE location Like '%states%'
GROUP BY location, date
ORDER BY Max_deaths DESC

----- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as Highest_Infection_Count, Max((total_cases/population))*100 as Percent_Population_Infected
FROM [Portfolio project]..CovidDeaths
Group by Location, Population
order by Percent_Population_Infected desc

---Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM [Portfolio project]..CovidDeaths
Where continent is not null 
Group by Location
order by Total_Death_Count desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM [Portfolio project]..CovidDeaths
Where continent is  not null 
Group by continent
order by Total_Death_Count desc

-- GLOBAL NUMBERS
---Number of total cases, deaths and death_percentage by date
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
FROM [Portfolio project]..CovidDeaths
Where continent is  not null 
Group by date
order by 1,2

---Number of total cases, deaths and death_percentage in the world.
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
FROM [Portfolio project]..CovidDeaths
Where continent is  not null 
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Cumulative_of_PeopleVaccinated
From [Portfolio project]..CovidDeaths dea
Join [Portfolio project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Cumulative_of_PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Cumulative_of_PeopleVaccinated
From [Portfolio project]..CovidDeaths dea
Join [Portfolio project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (Cumulative_of_PeopleVaccinated/Population)*100 AS percentage_vaccinated
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations INT,
Cumulative_of_PeopleVaccinated INT
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Cumulative_of_PeopleVaccinated
From [Portfolio project]..CovidDeaths dea
Join [Portfolio project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *, (Cumulative_of_PeopleVaccinated/Population)*100 AS percentage_vaccinated
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Cumulative_of_PeopleVaccinated
From [Portfolio project]..CovidDeaths dea
Join [Portfolio project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



CREATE VIEW Total_vaccinations as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Cumulative_of_PeopleVaccinated
From [Portfolio project]..CovidDeaths dea
Join [Portfolio project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
