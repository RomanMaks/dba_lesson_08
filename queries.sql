-- 1. Установите ограничения на таблицу товаров:
  
  -- 1. На цены товаров
    ALTER TABLE products ADD CHECK (price > 0);
  
  -- 2. На артикулы
    ALTER TABLE products ADD CHECK (length(vendor_code) = 10);
  
  -- 3. На поле "есть на складе"
    ALTER TABLE products ADD CHECK (goods_in_stock >= 0);

-- 2. Придумайте еще не менее двух ограничений в других таблицах 
--    будущего интернет-магазина и реализуйте их
  ALTER TABLE brands ADD CHECK (length(name) > 0);
  ALTER TABLE brands ADD CHECK (class SIMILAR TO '[A-Z]');

-- 3. Допустим, что поступило требование: каждый товар может отныне 
--    находится в нескольких категориях сразу. Перепроектируйте таблицу 
--    товаров, используя поле categories bigint[] и напишите запросы:
  -- Удаляем связь
    ALTER TABLE products DROP CONSTRAINT products_brand_id_fkey;

  -- Меняем тип поля
    ALTER TABLE products ALTER COLUMN cat_id TYPE bigint[] USING array[cat_id]::bigint[];
  
  -- 1. Выбирающий все товары из заданной категории
    SELECT *
    FROM products
    WHERE 6 = ANY(cat_id)
  
  -- 2. Выбирающий все категории и количество товаров в каждой из них
    SELECT
      *,
      (
        SELECT COUNT(*)
        FROM products
        WHERE categories.id = ANY(products.cat_id)
      )
    FROM categories
  
  -- 3. Добавляющий определенный товар в определенную категорию (вам 
  --    придется найти нужную функцию для работы с массивами)
    INSERT INTO products (
      vendor_code, 
      name, 
      price, 
      old_price, 
      picture, 
      admission, 
      goods_in_stock, 
      brand_id, cat_id
    ) VALUES (
      '0000000021',
      'Полтенце',
      100,
      0,
      'http://www.test.ru/img21.jpg',
      '2018-07-04',
      100,
      null,
      ARRAY[4]
    )