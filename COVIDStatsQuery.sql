Select * FROM PortfolioProject..CovidDeaths
WHERE Continent is null
ORDER BY 3, 4

--Select * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

--Select Location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1, 2

--Total Cases vs Total Deaths in Canada

Select Location, Population, date, ((cast(total_deaths as float))/(cast(Population as float)))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location Like '%Canada%'


--Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((cast(total_cases as float))/(cast(Population as float)))*100 AS PopInfectedPercentage
FROM PortfolioProject..CovidDeaths
--WHERE Location Like '%Canada%'
Group By Location, Population
ORDER BY PopInfectedPercentage DESC

--Countries with Highest Death Count compared to Population

Select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location Like '%Canada%'
WHERE Continent is not null
Group By Location
ORDER BY TotalDeathCount DESC


--Break down by continent
Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE Location Like '%Canada%'
WHERE Continent is not null
Group By continent
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS

Select SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, (SUM(new_deaths)/NULLIF(SUM(new_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--GROUP BY date
order by 1,2

--Looking at toal population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER BY dea.location, dea.date) Vaccines_to_date
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
Order by 2, 3


--USE TEMP TABLE

With PopvsVac (continent, location, date, population, new_vaccinations, Vaccines_to_date) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER BY dea.location, dea.date) Vaccines_to_date
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
)

SELECT *, (Vaccines_to_date/population)*100  AS PercentVaccinated FROM PopvsVac


--CREATE VIEW

CREATE VIEW PercentPopVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition By dea.Location ORDER BY dea.location, dea.date) Vaccines_to_date
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent is not null
