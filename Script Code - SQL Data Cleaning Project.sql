

-- Cleaning Data in SQL Queries


Select *
From project_data_cleaning.nashvillehousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From project_data_cleaning.nashvillehousing
-- Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress)
From project_data_cleaning.nashvillehousing a
JOIN project_data_cleaning.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null;


Update nashvillehousing a
JOIN project_data_cleaning.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
    SET a.PropertyAddress = b.PropertyAddress
Where a.PropertyAddress is null;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From project_data_cleaning.nashvillehousing;
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1 ) as Address
From project_data_cleaning.nashvillehousing;



ALTER TABLE nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 );


ALTER TABLE nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);




Select *
From project_data_cleaning.nashvillehousing;





Select OwnerAddress
From project_data_cleaning.nashvillehousing;



Select
    SUBSTRING_INDEX(OwnerAddress, ', ', 1) AS address,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ', ', -2), ', ', 1) AS city,
    SUBSTRING_INDEX(OwnerAddress, ', ', -1) AS state
From project_data_cleaning.nashvillehousing;



ALTER TABLE nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update nashvillehousing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ', ', 1);


ALTER TABLE nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update nashvillehousing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ', ', -2), ', ', 1);


ALTER TABLE nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update nashvillehousing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ', ', -1);



Select *
From project_data_cleaning.nashvillehousing;




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From project_data_cleaning.nashvillehousing
Group by SoldAsVacant
order by 2;




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From project_data_cleaning.nashvillehousing;


Update nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove duplicates


    SELECT ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    FROM project_data_cleaning.nashvillehousing
	GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    HAVING COUNT(*) > 1
    Order by PropertyAddress;
    
    
    
    
    DELETE t1
FROM project_data_cleaning.nashvillehousing t1
JOIN (
    SELECT ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    FROM project_data_cleaning.nashvillehousing
    GROUP BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    HAVING COUNT(*) > 1
) t2
ON t1.ParcelID = t2.ParcelID AND t1.PropertyAddress = t2.PropertyAddress AND t1.SalePrice = t2.SalePrice  AND t1.SaleDate = t2.SaleDate AND t1.LegalReference = t2.LegalReference;

  

Select *
From project_data_cleaning.nashvillehousing;




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From project_data_cleaning.nashvillehousing;


ALTER TABLE project_data_cleaning.nashvillehousing
DROP COLUMN OwnerAddress;

ALTER TABLE project_data_cleaning.nashvillehousing
DROP COLUMN TaxDistrict;

ALTER TABLE project_data_cleaning.nashvillehousing
DROP COLUMN PropertyAddress;

ALTER TABLE project_data_cleaning.nashvillehousing
DROP COLUMN SaleDate;