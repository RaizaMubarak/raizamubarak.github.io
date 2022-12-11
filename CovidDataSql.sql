use PortfolioProject;

DROP TABLE IF EXISTS Covid_Deaths;
CREATE TABLE Covid_Deaths (
    iso_code VARCHAR(100),
    continent VARCHAR(100),
    location VARCHAR(100),
    date DATE,
    population INT,
    total_cases INT,
    new_cases INT,
    new_cases_smoothed VARCHAR(100),
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed VARCHAR(100),
    new_cases_per_million VARCHAR(100),
    new_cases_smoothed_per_million VARCHAR(100),
    total_deaths_per_million VARCHAR(100),
    new_deaths_per_million VARCHAR(100),
    new_deaths_smoothed_per_million VARCHAR(100),
    reproduction_rate VARCHAR(100),
    icu_patients INT,
    icu_patients_per_million VARCHAR(100),
    hosp_patients INT,
    hosp_patients_per_million VARCHAR(100),
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million VARCHAR(100),
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million VARCHAR(100)
);
                        
SET GLOBAL LOCAL_INFILE=1;
                        
LOAD DATA LOCAL INFILE '/Users/mac/Downloads/Covid_Deaths.csv'
INTO TABLE Covid_Deaths
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
Ignore 1 rows;
				
					


SELECT 
    *
FROM
    Covid_Deaths;

DROP TABLE IF EXISTS 	Covid_Vaccinations;
CREATE TABLE Covid_Vaccinations( iso_code varchar(100),
															continent varchar(100),
                                                            location varchar(100),
                                                            date date, 
                                                            new_tests int,
                                                            total_tests int,
															total_vaccinations int,
                                                            people_vaccinated int,
                                                            people_fully_vaccinated int,
                                                            total_boosters int,
                                                            new_vaccinations int,
                                                            total_boosters_per_hundred varchar(100),
                                                            median_age varchar(100),
                                                            aged_65_older varchar(100),aged_70_older varchar(100));


                                                         
                                                         
LOAD DATA LOCAL INFILE '/Users/mac/Downloads/Covid_Vaccinations.csv'
                        INTO TABLE Covid_Vaccinations
                        FIELDS TERMINATED BY ';'
                        ENCLOSED BY '"'
                        LINES TERMINATED BY '\n'
                        Ignore 1 rows;







SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    Covid_Deaths
WHERE
    continent IS NOT NULL
ORDER BY location , date;


##percentage of deaths compared to total cases in everyday

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS percentage_deaths
FROM
    Covid_Deaths
WHERE
    continent > ' ';

##total cases vs country's population in everyday
SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS cases_vs_population
FROM
    Covid_Deaths
WHERE
    continent > ' ';


##finding the infection rate
SELECT 
    location,
    population,
    MAX(total_cases) AS highest_total_cases,
    (MAX(total_cases) / population) * 100 AS infection_rate
FROM
    Covid_Deaths
WHERE
    continent IS NOT NULL
GROUP BY location , population
ORDER BY infection_rate DESC;


##continents and total death count
SELECT 
    continent, MAX(total_deaths) AS total_deaths
FROM
    Covid_Deaths
WHERE
    continent > ' '
        AND continent IS NOT NULL
GROUP BY continent
ORDER BY MAX(total_deaths) DESC;

## values globally total cases vs total deaths
SELECT 
    date,
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS death_percentage
FROM
    Covid_Deaths
WHERE
    continent > ' '
GROUP BY date
ORDER BY date;

##Total cases globally each  day

SELECT 
    date, SUM(total_cases) AS total_cases
FROM
    Covid_Deaths
WHERE
    continent > ' '
GROUP BY date
ORDER BY date;

##Joining the two tables

SELECT 
    *
FROM
    Covid_Vaccinations;

SELECT 
    *
FROM
    Covid_Deaths cd
        JOIN
    Covid_Vaccinations cv ON cd.location = cv.location
        AND cd.date = cv.date;
        
        
##total population vs vaccinated people
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    cv.total_vaccinations,
    (cv.total_vaccinations / cd.population) * 100 as vaccinated_vs_population
FROM
    Covid_Deaths cd
        JOIN
    Covid_Vaccinations cv ON cd.location = cv.location
        AND cd.date = cv.date
WHERE
    cd.continent > ' ';

