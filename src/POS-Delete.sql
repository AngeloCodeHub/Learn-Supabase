-- 宣告變數
SET @date_before = '2024-10-15 00:00:00';
DELETE FROM salemer
WHERE SL_Time < @date_before;
DELETE FROM waste
WHERE PayTime < '2024-10-15 00:00:00';
DELETE FROM buycardhis
WHERE CardTime < '2024-10-15 00:00:00';
DELETE FROM cuspaper
WHERE wcDate < '2024-10-15 00:00:00';
DELETE FROM killpayrecord
WHERE KL_TIME < '2024-10-15 00:00:00';
DELETE FROM doend
WHERE idtime < '2024-10-15 00:00:00';
DELETE FROM propose
WHERE PR_TIME < '2024-10-15 00:00:00';
DELETE FROM refund
WHERE rTime < '2024-10-15 00:00:00';