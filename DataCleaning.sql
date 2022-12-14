USE PortfolioProject;


DROP TABLE IF EXISTS Housing_Data;
CREATE TABLE Housing_Data (
    UniqueID int,
    ParcelID nvarchar(255),
    LandUse nvarchar (255),
    PropertyAddress nvarchar(255),
    SaleDate Date,
    SalePrice int,
    LegalReference nvarchar(255),
    SoldAsVacant nvarchar(255),
    OwnerName nvarchar(255),
    OwnerAddress nvarchar(255),
    Acreage nvarchar(255),TaxDistrict nvarchar(255),
    LandValue int,
    BuildingValue int,
    TotalValue int,
    YearBuilt int,
    Bedrooms int,
    FullBath int,
    HalfBath int
);

SET GLOBAL LOCAL_INFILE=1;

LOAD DATA LOCAL INFILE '/Users/mac/Desktop/PortFolio/Nashville Housing Data for Data Cleaning.csv'
INTO TABLE Housing_Data
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
Ignore 1 rows;

SELECT 
    *
FROM
    Housing_Data;



##populate property address

#Converting empty values to null
UPDATE Housing_Data 
SET 
    PropertyAddress = NULLIF(PropertyAddress, ' ');

SELECT 
    *
FROM
    Housing_Data
WHERE
    PropertyAddress IS NULL;


SELECT 
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM
    Housing_Data a
        JOIN
    Housing_Data b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> B.UniqueID
WHERE
    a.PropertyAddress IS NULL;



UPDATE Housing_Data a
        JOIN
    Housing_Data b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> B.UniqueID 
SET 
    a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE
    a.PropertyAddress IS NULL;


##Breaking the address into separate columns
#PropertyAddress


SELECT 
    PropertyAddress
FROM
    Housing_Data;


Alter table Housing_Data
add PropertySpliAddress varchar(255);

Alter table Housing_Data
add PropertySplitCity varchar(255);

UPDATE Housing_Data 
SET 
    PropertySpliAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

UPDATE Housing_Data 
SET 
    PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', - 1);

#Splitting OwnerAddress
Alter table Housing_Data
add OwnerSplitAddress varchar(255);

Alter table Housing_Data
add OwnerSplitCity varchar(255);

Alter table Housing_Data
add OwnerSplitState varchar(255);

UPDATE Housing_Data 
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

UPDATE Housing_Data 
SET 
    OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),
            ',',
            - 1);

UPDATE Housing_Data 
SET 
    OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', - 1);

##Change Y and N to Yes and No in SoldAsVacant

SELECT DISTINCT
    (SoldAsVacant)
FROM
    Housing_Data;

SELECT 
    SoldAsVacant,
    CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
FROM
    Housing_Data;

UPDATE Housing_Data 
SET 
    SoldAsVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;
     

##removing unwanted columns
ALTER TABLE Housing_Data
DROP COLUMN PropertyAddress;

ALTER TABLE Housing_Data
DROP COLUMN OwnerAddress;
