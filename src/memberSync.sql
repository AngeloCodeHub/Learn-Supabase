-- step 1 處理非重複資料
-- 插入非重複資料
INSERT INTO member (
        Mem_Code,
        Mem_EXTCode,
        Mem_Name,
        Mem_sex,
        Mem_Birthday,
        Mem_selfcode,
        Mem_TEL,
        Mem_ID,
        Mem_Pass,
        Mem_Email,
        Mem_ADR,
        Mem_Note,
        Mem_DEF1,
        Mem_DEF2,
        Mem_DEF3,
        Mem_bonus,
        Mem_Score,
        Mem_Pic,
        Mem_LastLogin
    )
SELECT Mem_Code,
    Mem_EXTCode,
    Mem_Name,
    Mem_sex,
    Mem_Birthday,
    Mem_selfcode,
    Mem_TEL,
    Mem_ID,
    Mem_Pass,
    Mem_Email,
    Mem_ADR,
    Mem_Note,
    Mem_DEF1,
    Mem_DEF2,
    Mem_DEF3,
    Mem_bonus,
    Mem_Score,
    Mem_Pic,
    Mem_LastLogin
FROM member_fen
WHERE Mem_Code NOT IN (
        SELECT Mem_Code
        FROM member_nan
    )
UNION ALL
SELECT Mem_Code,
    Mem_EXTCode,
    Mem_Name,
    Mem_sex,
    Mem_Birthday,
    Mem_selfcode,
    Mem_TEL,
    Mem_ID,
    Mem_Pass,
    Mem_Email,
    Mem_ADR,
    Mem_Note,
    Mem_DEF1,
    Mem_DEF2,
    Mem_DEF3,
    Mem_bonus,
    Mem_Score,
    Mem_Pic,
    Mem_LastLogin
FROM member_nan
WHERE Mem_Code NOT IN (
        SELECT Mem_Code
        FROM member_fen
    );
-- 刪除member_fen非重複資料
DELETE FROM member_fen
WHERE Mem_Code NOT IN (
        SELECT Mem_Code
        FROM member_nan
    );
-- 刪除member_nan非重複資料
DELETE FROM member_nan
WHERE Mem_Code NOT IN (
        SELECT Mem_Code
        FROM member_fen
    );
-- 
-- 
-- step 2 處理重複資料
-- 兩方Mem_LastLogin都是null
INSERT INTO member (
        Mem_Code,
        Mem_EXTCode,
        Mem_Name,
        Mem_sex,
        Mem_Birthday,
        Mem_selfcode,
        Mem_TEL,
        Mem_ID,
        Mem_Pass,
        Mem_Email,
        Mem_ADR,
        Mem_Note,
        Mem_DEF1,
        Mem_DEF2,
        Mem_DEF3,
        Mem_bonus,
        Mem_Score,
        Mem_Pic,
        Mem_LastLogin
    )
SELECT fen.Mem_Code,
    fen.Mem_EXTCode,
    fen.Mem_Name,
    fen.Mem_sex,
    fen.Mem_Birthday,
    fen.Mem_selfcode,
    fen.Mem_TEL,
    fen.Mem_ID,
    fen.Mem_Pass,
    fen.Mem_Email,
    fen.Mem_ADR,
    fen.Mem_Note,
    fen.Mem_DEF1,
    fen.Mem_DEF2,
    fen.Mem_DEF3,
    fen.Mem_bonus,
    fen.Mem_Score,
    fen.Mem_Pic,
    fen.Mem_LastLogin
FROM member_fen fen
    JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
WHERE fen.Mem_LastLogin IS NULL
    AND nan.Mem_LastLogin IS NULL;
-- 
-- 兩方Mem_LastLogin都非null，選擇最後登入時間較晚的
INSERT INTO member (
        Mem_Code,
        Mem_EXTCode,
        Mem_Name,
        Mem_sex,
        Mem_Birthday,
        Mem_selfcode,
        Mem_TEL,
        Mem_ID,
        Mem_Pass,
        Mem_Email,
        Mem_ADR,
        Mem_Note,
        Mem_DEF1,
        Mem_DEF2,
        Mem_DEF3,
        Mem_bonus,
        Mem_Score,
        Mem_Pic,
        Mem_LastLogin
    )
SELECT combined.Mem_Code,
    combined.Mem_EXTCode,
    combined.Mem_Name,
    combined.Mem_sex,
    combined.Mem_Birthday,
    combined.Mem_selfcode,
    combined.Mem_TEL,
    combined.Mem_ID,
    combined.Mem_Pass,
    combined.Mem_Email,
    combined.Mem_ADR,
    combined.Mem_Note,
    combined.Mem_DEF1,
    combined.Mem_DEF2,
    combined.Mem_DEF3,
    combined.Mem_bonus,
    combined.Mem_Score,
    combined.Mem_Pic,
    combined.Mem_LastLogin
FROM (
        SELECT fen.Mem_Code,
            fen.Mem_EXTCode,
            fen.Mem_Name,
            fen.Mem_sex,
            fen.Mem_Birthday,
            fen.Mem_selfcode,
            fen.Mem_TEL,
            fen.Mem_ID,
            fen.Mem_Pass,
            fen.Mem_Email,
            fen.Mem_ADR,
            fen.Mem_Note,
            fen.Mem_DEF1,
            fen.Mem_DEF2,
            fen.Mem_DEF3,
            fen.Mem_bonus,
            fen.Mem_Score,
            fen.Mem_Pic,
            fen.Mem_LastLogin
        FROM member_fen fen
            JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
        WHERE fen.Mem_LastLogin IS NOT NULL
            AND nan.Mem_LastLogin IS NOT NULL
            AND fen.Mem_LastLogin > nan.Mem_LastLogin -- Choose from member_fen
        UNION ALL
        SELECT nan.Mem_Code,
            nan.Mem_EXTCode,
            nan.Mem_Name,
            nan.Mem_sex,
            nan.Mem_Birthday,
            nan.Mem_selfcode,
            nan.Mem_TEL,
            nan.Mem_ID,
            nan.Mem_Pass,
            nan.Mem_Email,
            nan.Mem_ADR,
            nan.Mem_Note,
            nan.Mem_DEF1,
            nan.Mem_DEF2,
            nan.Mem_DEF3,
            nan.Mem_bonus,
            nan.Mem_Score,
            nan.Mem_Pic,
            nan.Mem_LastLogin
        FROM member_fen fen
            JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
        WHERE fen.Mem_LastLogin IS NOT NULL
            AND nan.Mem_LastLogin IS NOT NULL
            AND nan.Mem_LastLogin > fen.Mem_LastLogin -- Choose from member_nan
    ) AS combined;
-- 
-- 只有一方Mem_LastLogin是null，直接選擇有資料的一方
INSERT INTO member (
        Mem_Code,
        Mem_EXTCode,
        Mem_Name,
        Mem_sex,
        Mem_Birthday,
        Mem_selfcode,
        Mem_TEL,
        Mem_ID,
        Mem_Pass,
        Mem_Email,
        Mem_ADR,
        Mem_Note,
        Mem_DEF1,
        Mem_DEF2,
        Mem_DEF3,
        Mem_bonus,
        Mem_Score,
        Mem_Pic,
        Mem_LastLogin
    )
SELECT combined.Mem_Code,
    combined.Mem_EXTCode,
    combined.Mem_Name,
    combined.Mem_sex,
    combined.Mem_Birthday,
    combined.Mem_selfcode,
    combined.Mem_TEL,
    combined.Mem_ID,
    combined.Mem_Pass,
    combined.Mem_Email,
    combined.Mem_ADR,
    combined.Mem_Note,
    combined.Mem_DEF1,
    combined.Mem_DEF2,
    combined.Mem_DEF3,
    combined.Mem_bonus,
    combined.Mem_Score,
    combined.Mem_Pic,
    combined.Mem_LastLogin
FROM (
        SELECT fen.Mem_Code,
            fen.Mem_EXTCode,
            fen.Mem_Name,
            fen.Mem_sex,
            fen.Mem_Birthday,
            fen.Mem_selfcode,
            fen.Mem_TEL,
            fen.Mem_ID,
            fen.Mem_Pass,
            fen.Mem_Email,
            fen.Mem_ADR,
            fen.Mem_Note,
            fen.Mem_DEF1,
            fen.Mem_DEF2,
            fen.Mem_DEF3,
            fen.Mem_bonus,
            fen.Mem_Score,
            fen.Mem_Pic,
            fen.Mem_LastLogin
        FROM member_fen fen
            JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
        WHERE fen.Mem_LastLogin IS NOT NULL
            AND nan.Mem_LastLogin IS NULL -- Choose from member_fen
        UNION ALL
        SELECT nan.Mem_Code,
            nan.Mem_EXTCode,
            nan.Mem_Name,
            nan.Mem_sex,
            nan.Mem_Birthday,
            nan.Mem_selfcode,
            nan.Mem_TEL,
            nan.Mem_ID,
            nan.Mem_Pass,
            nan.Mem_Email,
            nan.Mem_ADR,
            nan.Mem_Note,
            nan.Mem_DEF1,
            nan.Mem_DEF2,
            nan.Mem_DEF3,
            nan.Mem_bonus,
            nan.Mem_Score,
            nan.Mem_Pic,
            nan.Mem_LastLogin
        FROM member_fen fen
            JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
        WHERE fen.Mem_LastLogin IS NULL
            AND nan.Mem_LastLogin IS NOT NULL -- Choose from member_nan
    ) AS combined;
-- 兩方Mem_LastLogin都非null，但Mem_LastLogin是一樣的
INSERT INTO member (
        Mem_Code,
        Mem_EXTCode,
        Mem_Name,
        Mem_sex,
        Mem_Birthday,
        Mem_selfcode,
        Mem_TEL,
        Mem_ID,
        Mem_Pass,
        Mem_Email,
        Mem_ADR,
        Mem_Note,
        Mem_DEF1,
        Mem_DEF2,
        Mem_DEF3,
        Mem_bonus,
        Mem_Score,
        Mem_Pic,
        Mem_LastLogin
    )
SELECT fen.Mem_Code,
    fen.Mem_EXTCode,
    fen.Mem_Name,
    fen.Mem_sex,
    fen.Mem_Birthday,
    fen.Mem_selfcode,
    fen.Mem_TEL,
    fen.Mem_ID,
    fen.Mem_Pass,
    fen.Mem_Email,
    fen.Mem_ADR,
    fen.Mem_Note,
    fen.Mem_DEF1,
    fen.Mem_DEF2,
    fen.Mem_DEF3,
    fen.Mem_bonus,
    fen.Mem_Score,
    fen.Mem_Pic,
    fen.Mem_LastLogin
FROM member_fen fen
    JOIN member_nan nan ON fen.Mem_Code = nan.Mem_Code
WHERE fen.Mem_LastLogin = nan.Mem_LastLogin;