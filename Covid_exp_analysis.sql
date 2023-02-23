CREATE TABLE CovidDeaths (
	iso_code VARCHAR,
 	continent VARCHAR,
 	location VARCHAR,
 	date VARCHAR,
 	total_cases int,
	new_cases VARCHAR,
 	new_cases_smoothed FLOAT,
 	total_deaths int,
	new_deaths int,
	new_deaths_smoothed FLOAT,
	total_cases_per_million FLOAT,
	new_cases_per_million FLOAT,
	new_cases_smoothed_per_million FLOAT,
 	total_deaths_per_million FLOAT,
 	new_deaths_per_million FLOAT,
 	new_deaths_smoothed_per_million FLOAT,
 	reproduction_rate FLOAT,
	icu_patients int,
 	icu_patients_per_million FLOAT,
	hosp_patients VARCHAR,
 	hosp_patients_per_million FLOAT,
 	weekly_icu_admissions FLOAT,
 	weekly_icu_admissions_per_million FLOAT,
 	weekly_hosp_admissions FLOAT,
 	weekly_hosp_admissions_per_million FLOAT,
 	new_tests int,
 	total_tests int,
 	total_tests_per_thousand FLOAT,
 	new_tests_per_thousand FLOAT,
	new_tests_smoothed int,
 	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT,
 	tests_per_case FLOAT,
	tests_units VARCHAR,
	total_vaccinations int,
 	people_vaccinated int,
 	people_fully_vaccinated int,
 	new_vaccinations int,
 	new_vaccinations_smoothed FLOAT,
 	total_vaccinations_per_hundred FLOAT,
 	people_vaccinated_per_hundred FLOAT,
 	people_fully_vaccinated_per_hundred FLOAT,
	new_vaccinations_smoothed_per_million FLOAT,
 	stringency_index FLOAT,
	population bigint,
 	population_density FLOAT,
 	median_age FLOAt,
 	aged_65_older FLOAT,
 	aged_70_older FLOAT,
 	gdp_per_capita FLOAT,
 	extreme_poverty FLOAT,
 	cardiovasc_death_rate FLOAT,
 	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
 	handwashing_facilities FLOAT,
 	hospital_beds_per_thousand FLOAT,
 	life_expectancy FLOAT,
 	human_development_index FLOAT
);

CREATE TABLE CovidVaccinations(
	iso_code VARCHAR,
 	continent VARCHAR,
 	location VARCHAR,
 	date VARCHAR,
 	total_cases int,
	new_cases VARCHAR,
 	new_cases_smoothed FLOAT,
 	total_deaths int,
	new_deaths int,
	new_deaths_smoothed FLOAT,
	total_cases_per_million FLOAT,
	new_cases_per_million FLOAT,
	new_cases_smoothed_per_million FLOAT,
 	total_deaths_per_million FLOAT,
 	new_deaths_per_million FLOAT,
 	new_deaths_smoothed_per_million FLOAT,
 	reproduction_rate FLOAT,
	icu_patients int,
 	icu_patients_per_million FLOAT,
	hosp_patients VARCHAR,
 	hosp_patients_per_million FLOAT,
 	weekly_icu_admissions FLOAT,
 	weekly_icu_admissions_per_million FLOAT,
 	weekly_hosp_admissions FLOAT,
 	weekly_hosp_admissions_per_million FLOAT,
 	new_tests FLOAT,
 	total_tests FLOAT,
 	total_tests_per_thousand FLOAT,
 	new_tests_per_thousand FLOAT,
	new_tests_smoothed FLOAT,
 	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT,
 	tests_per_case FLOAT,
	tests_units VARCHAR,
	total_vaccinations FLOAT,
 	people_vaccinated FLOAT,
 	people_fully_vaccinated FLOAT,
 	new_vaccinations integer,
 	new_vaccinations_smoothed FLOAT,
 	total_vaccinations_per_hundred FLOAT,
 	people_vaccinated_per_hundred FLOAT,
 	people_fully_vaccinated_per_hundred FLOAT,
	new_vaccinations_smoothed_per_million FLOAT,
 	stringency_index FLOAT,
	population bigint,
 	population_density FLOAT,
 	median_age FLOAt,
 	aged_65_older FLOAT,
 	aged_70_older FLOAT,
 	gdp_per_capita FLOAT,
 	extreme_poverty FLOAT,
 	cardiovasc_death_rate FLOAT,
 	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
 	handwashing_facilities FLOAT,
 	hospital_beds_per_thousand FLOAT,
 	life_expectancy FLOAT,
 	human_development_index FLOAT
);

COPY Coviddeaths
FROM 'C:\Users\Public\covidproject\CovidDeaths.csv'
DELIMITER ','
CSV Header;

COPY Covidvaccinations
FROM 'C:\Users\Public\covidproject\CovidVaccinations.csv'
DELIMITER ','
CSV Header;

--SELECT * FROM CovidDeaths
--ORDER By 3,4

SELECT * 
From coviddeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID in your country
ALTER TABLE coviddeaths add column deathpercentage float;
UPDATE coviddeaths set deathpercentage= (total_deaths/total_cases)*100;
ALTER TABLE coviddeaths DROP column deathpercentage;
SELECT location, date, total_cases, total_deaths, deathpercentage
From  coviddeaths
Where location like 'United States'
order by 1,2

-- Looking total cases vs Population
Select location, date, total_cases, population, (total_cases/population)*100 as Casespercentage
FROM coviddeaths
WHERE location like 'United States'
order by 1,2

-- Looking countries with highest infection rates compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Higuest Death count per Population
Select Location, MAX(total_deaths) as TotalDeathCount
From coviddeaths
Group by location
order by TotalDeathCount desc

--LET's BREAK THINGS DOWN BY CONTINENT

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From coviddeaths
where continent is null
group by location
order by TotalDeathCount desc

--Global numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM coviddeaths
Where continent is not null 
order by 1,2

Select * 
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations Vac
	On dea.location = vac.location
	and dea.date = vac.date




