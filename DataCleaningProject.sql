
 /*
 1-Standerdize Data Format
 2-Populate Property Address Data
 3-Breaking out Adress into Individual Columns (Address, City, State)
 4-Change Y and N to Yes and No in "Sold as Vacant" field
 5-Remove Duplicates
 6-Delete Unused Columns
 */

------------------------------------------------------------------------------------------------------------------
-- 1
SELECT * FROM NashvilleHousing

Select SaleDateCoverted 
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateCoverted Date;

UPDATE NashvilleHousing
SET SaleDateCoverted = Convert(Date,SaleDate)

-----------------------------------------------------------------------------------------------------------------
-- 2
SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress is null  -- we do have null values
-- Many of the properties has the same parcelID and property Address, if one has parcelId and address and the other is the same with no address then populate it 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing as a
JOIN NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing as a
JOIN NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
-- No there is No Null Values in PropertyAddress

-----------------------------------------------------------------------------------------------------------------
-- 3
SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM NashvilleHousing


SELECT OwnerAddress From NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * From NashvilleHousing

-----------------------------------------------------------------------------------------------
-- 4
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order By 2

Select SoldAsVacant,
Case 
When SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
From NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
Case 
When SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

--------------------------------------------------------------------------------------
-- 5
WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress, SalePrice, SaleDate, LegalReference
	Order By UniqueID
	) row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
DELETE FROM RowNumCTE WHERE row_num > 1

------------------------------------------------------------------------------------------
-- 6
ALTER TABLE NashvilleHousing
Drop Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

SELECT * FROM NashvilleHousing



-- A COMPLETE CLEAN DATA

