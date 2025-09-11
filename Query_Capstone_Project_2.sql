
-- a) Berapa banyak transaksi di table orders?
SELECT COUNT(*) AS total_transaksi
FROM orders;

-- b) Total nilai (SUM) order 
SELECT sum(total)  AS total_transaksi 
FROM orders o;

-- c) 10 product dengan transaksi ber-diskon terbanyak
SELECT 
	p.title AS product_title,
	count(o.discount) AS total_order_diskon
FROM orders o 
JOIN products p ON o.id = p.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- d) Total order (SUM) per kategori produk, urut tertinggi→terendah
WITH total_order_category AS (
	SELECT
		p.category,
		sum(o.total ) AS sum_total
	FROM orders o 
	JOIN products p ON o.id = p.id
	GROUP BY 1
	ORDER BY 2 DESC
)
SELECT * FROM total_order_category;

-- e) Total order (SUM) per title dengan filter rating produk >= 4
WITH total_order_title AS (
	SELECT
		p.title,
		sum(o.total ) AS sum_total
	FROM orders o 
	JOIN products p ON o.id = p.id
	WHERE p.rating >=4
	GROUP BY 1
	ORDER BY 2 DESC
)

SELECT * FROM total_order_title;

-- soal no.6
WITH doohickey_reviews AS (
	SELECT 
		p.created_at,
		r.body, 
		r.rating
	FROM reviews r
	JOIN products p  ON r.id =p.id
	WHERE  p.category  = 'Doohickey' AND r.rating <=3
	ORDER BY 1 DESC 
)
SELECT * FROM doohickey_reviews;

-- g-1) List unik sumber user
SELECT
	distinct(source),
	COUNT(source)
FROM users u
GROUP BY 1;

-- h) Hitung user yang memakai email @gmail.com
SELECT count(*) AS total_user_gmail
FROM users
WHERE email LIKE  '%gmail.com';

-- i) Produk dengan price antara 30 dan 50, urut terbaru → terlama
SELECT 
	id,
	title,
	price,
	created_at 
FROM products p
WHERE price BETWEEN 30 AND 50 
ORDER BY 4 DESC ;

-- j) Buat view untuk user lahir >= 1998-01-01
CREATE VIEW users_younger AS (
SELECT  
	name,
	email,
	address,
	birth_date 
FROM users
WHERE birth_date > '1997'
ORDER BY 4)

SELECT * FROM users_younger;

-- soal no. 11
WITH duplicate_products AS (
	SELECT 
		id, created_at, title, category, vendor,
		ROW_NUMBER() OVER (PARTITION BY title ORDER BY created_at) AS rn
	FROM products
    )
SELECT * FROM duplicate_products
WHERE rn > 1
ORDER BY title , created_at;
