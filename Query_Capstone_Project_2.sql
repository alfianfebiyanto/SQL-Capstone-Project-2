-- a) Hitunglah ada berapa banyak transaksi di table Order? pada kolom id
SELECT COUNT('id') AS total_kolom_orders
FROM orders;

-- b) Hitunglah berapa jumlah Order dari seluruh transaksi di Table Order? pada kolom total
SELECT sum(total)  AS total_transaksi 
FROM orders o;

-- c)  Hitung 10 product yang sering memberikan discount ?

 SELECT 
	p.title AS product_title,
	count(o.discount) AS total_order_diskon
FROM orders o 
JOIN products p ON o.id = p.id
GROUP BY product_title 
ORDER BY total_order_diskon   DESC
LIMIT 10;

-- d) Hitung  jumlah order Total order (SUM) per kategori produk, urut tertinggi→terendah

WITH total_order_category AS (
	SELECT
		p.category AS tabel_produk,
		sum(o.total ) AS sum_total
	FROM orders o 
	JOIN products p ON o.id = p.id
	GROUP BY tabel_produk 
	ORDER BY 2 DESC
)
SELECT * FROM total_order_category;

-- e) Hitung Total order (SUM) per title dengan filter rating produk >= 4?
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

-- f) Cari semua review  product ="Doohikey" dan rating<=3, urukan dari tanggal terbaru -> terlama
WITH doohickey_reviews AS (
	SELECT 
		p.created_at AS date,
		r.body AS descriptions, 
		r.rating
	FROM reviews r
	JOIN products p  ON r.id =p.id
	WHERE  p.category  = 'Doohickey' AND r.rating <=3
	ORDER BY date DESC 
)
SELECT * FROM doohickey_reviews;

-- g) Ada berapa Source di tabel Users dan tidak duplikat(unik)?
SELECT
	distinct(source),
	COUNT(source)
FROM users u
GROUP BY 1;

-- h) Hitung user yang memakai email @gmail.com
SELECT count(email) AS total_user_gmail
FROM users
WHERE email LIKE  '%gmail.com';

-- i) Cari Produk dengan price antara 30 dan 50, urut terbaru → terlama
SELECT 
	id,
	title,
	price,
	created_at 
FROM products p
WHERE price BETWEEN 30 AND 50 
ORDER BY 4 DESC ;

-- j) Hitung user yang "lahir >= 1997" 
CREATE VIEW users_youngest AS (
SELECT  
	name,
	email,
	address,
	birth_date 
FROM users
WHERE birth_date > '1997'
ORDER BY birth_date)

SELECT * FROM users_youngest;

-- k) cari product yang vendornya lebih dari 1
WITH duplicate_products AS (
	SELECT 
		id, 
		created_at,
		title, category, 
		vendor,
		ROW_NUMBER() OVER (PARTITION BY title ORDER BY created_at) AS rn
	FROM products
    )
SELECT * FROM duplicate_products
WHERE rn > 1
ORDER BY title , created_at;
