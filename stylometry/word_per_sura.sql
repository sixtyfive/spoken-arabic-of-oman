SELECT
  sura,
  SUM(LENGTH(text)-LENGTH(REPLACE(text, ' ', ''))+1) AS words_per_sura
    FROM quran_text
      GROUP BY sura
      ORDER BY words_per_sura ASC;
