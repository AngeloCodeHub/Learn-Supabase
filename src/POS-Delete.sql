-- 宣告變數
SET @date_before = '2024-10-15 00:00:00';
DELETE FROM salemer
WHERE SL_Time < @date_before;
DELETE FROM waste
WHERE PayTime < @date_before;
DELETE FROM buycardhis
WHERE CardTime < @date_before;
DELETE FROM cuspaper
WHERE wcDate < @date_before;
DELETE FROM killpayrecord
WHERE KL_TIME < @date_before;
DELETE FROM doend
WHERE idtime < @date_before;
DELETE FROM propose
WHERE PR_TIME < @date_before;
DELETE FROM refund
WHERE rTime < @date_before;