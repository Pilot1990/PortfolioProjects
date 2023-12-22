SELECT*
FROM PortfolioProject..CovidDeath
ORDER BY 3,4


--SELECT*
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4


--Select the data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeath
ORDER BY 1,2


--Looking At Total Cases Vs Total Dealths


--SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeath
--ORDER BY 1,2

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeath
ORDER BY 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)
FROM PortfolioProject..CovidDeath
ORDER BY 1,2

SELECT Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
ORDER BY 1,2

--Showing The Likelyhood of dying if contracted covid19 in your country

SELECT Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE Location Like '%Nigeria%'
ORDER BY 1,2

--NOW, Lets look at the Total cases vs Population to show the percentage of people that got covid

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS CovidPercentage
FROM PortfolioProject..CovidDeath
WHERE Location Like '%Nigeria%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to population.

SELECT Location, population, Max(total_cases) AS HighestInfectionCount, Max(total_cases/population)*100 AS PercentagePopulationInfested
FROM PortfolioProject..CovidDeath
--WHERE Location Like '%Nigeria%'
GROUP BY Location, Population
ORDER BY 1,2

--NOW, Lets look at the Total cases vs Population to show the percentage of people that got covid

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS CovidPercentage
FROM PortfolioProject..CovidDeath
WHERE Location Like '%Nigeria%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to population.

SELECT Location, population, Max(total_cases) AS HighestInfectionCount, Max(total_cases/population)*100 AS PercentagePopulationInfested
FROM PortfolioProject..CovidDeath
WHERE Continent is not NULL
GROUP BY Location, Population
ORDER BY PercentagePopulationInfested Desc


--Showing Countries With Higest Death Count Per Population

SELECT Location, Max(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent is not NULL
GROUP BY Location
ORDER BY TotalDeathCount Desc


--NOW LET'S BREAK ITS DOWN BY CONTINENT

--Lets Get to see the Total Dealth Count Per continent

SELECT Location, Max(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent is NULL
GROUP BY Location
ORDER BY TotalDeathCount Desc

--Total Dealth Counts Per Each Continent

SELECT continent, Max(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE Continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount Desc

--NB Every other details gotten for each country can be derived using the same code by just replacing location with continent

--GLOBAL NUMBERS


SELECT Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent is not null
ORDER BY 1,2


SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent is not null
Group by date
ORDER BY 1,2

SELECT date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) As TotalDeath, SUM(cast(new_deaths as int))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent is not null
Group by date
ORDER BY 1,2


SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) As TotalDeath, SUM(cast(new_deaths as int))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent is not null
ORDER BY 1,2


--NOW LETS DIVE INTO VACCINATION

SELECT*
FROM PortfolioProject..CovidVaccinations

--LTS JOIN THE TWO DATA TOGETHER
SELECT*
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 

--Looking at total population vs vaccinations


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
order by 1,2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date)
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
order by 2,3


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
order by 2,3

--USING CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
--order by 2,3
)
SELECT*
FROM PopvsVac



with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
--order by 2,3
)
SELECT*, (RollingPeopleVaccinated/population)*100
FROM PopvsVac



---USING TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
--order by 2,3
SELECT*, (RollingPeopleVaccinated/population)*100 As PercentRollingPeopleVaccinated
FROM #PercentPopulationVaccinated


---CRATING VIEWS TO STORE DATA FOR LATER VISUALISATION

Create view PercenttPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
--order by 2,3

Use PortfolioProject
Go
Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as float)) Over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date 
Where dea.continent is not null
--order by 2,3

Select*
FROM PercentPopulationVaccinated



