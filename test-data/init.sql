-- Database de prueba para Manzana Verde
-- Tablas de ejemplo con datos de producción ficticios

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  country ENUM('PE', 'CO', 'MX', 'CL') NOT NULL,
  subscription_status ENUM('active', 'paused', 'cancelled') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de planes de suscripción
CREATE TABLE IF NOT EXISTS subscription_plans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(2) NOT NULL,
  price_cents INT NOT NULL,
  meals_per_day INT NOT NULL,
  days_per_week INT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de pedidos
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  plan_id INT NOT NULL,
  status ENUM('pending', 'confirmed', 'preparing', 'delivered', 'cancelled') DEFAULT 'pending',
  delivery_date DATE NOT NULL,
  total_cents INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (plan_id) REFERENCES subscription_plans(id)
);

-- Tabla de productos (comidas)
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  category ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
  calories INT NOT NULL,
  protein_g DECIMAL(5,2),
  carbs_g DECIMAL(5,2),
  fats_g DECIMAL(5,2),
  is_vegetarian BOOLEAN DEFAULT FALSE,
  is_vegan BOOLEAN DEFAULT FALSE,
  is_gluten_free BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de ejemplo
INSERT INTO users (email, name, country, subscription_status) VALUES
  ('juan.perez@example.com', 'Juan Pérez', 'PE', 'active'),
  ('maria.garcia@example.com', 'María García', 'CO', 'active'),
  ('carlos.rodriguez@example.com', 'Carlos Rodríguez', 'MX', 'paused'),
  ('ana.martinez@example.com', 'Ana Martínez', 'CL', 'active');

INSERT INTO subscription_plans (name, country, price_cents, meals_per_day, days_per_week, description) VALUES
  ('Plan Básico', 'PE', 15900, 2, 5, 'Almuerzo y cena, 5 días a la semana'),
  ('Plan Completo', 'PE', 24900, 3, 5, 'Desayuno, almuerzo y cena, 5 días a la semana'),
  ('Plan Premium', 'PE', 32900, 3, 7, 'Desayuno, almuerzo y cena, 7 días a la semana'),
  ('Plan Básico', 'CO', 18000, 2, 5, 'Almuerzo y cena, 5 días a la semana');

INSERT INTO products (name, category, calories, protein_g, carbs_g, fats_g, is_vegetarian, is_vegan, is_gluten_free) VALUES
  ('Bowl de Quinoa con Pollo', 'lunch', 450, 35, 50, 12, FALSE, FALSE, TRUE),
  ('Ensalada Verde con Salmón', 'dinner', 380, 28, 25, 18, FALSE, FALSE, TRUE),
  ('Avena con Frutas', 'breakfast', 320, 12, 55, 8, TRUE, TRUE, TRUE),
  ('Wrap Vegetariano', 'lunch', 400, 15, 52, 14, TRUE, FALSE, FALSE),
  ('Smoothie Bowl', 'breakfast', 280, 10, 45, 6, TRUE, TRUE, TRUE);

INSERT INTO orders (user_id, plan_id, status, delivery_date, total_cents) VALUES
  (1, 1, 'delivered', '2026-02-09', 15900),
  (1, 1, 'preparing', '2026-02-10', 15900),
  (2, 2, 'confirmed', '2026-02-11', 24900),
  (4, 3, 'pending', '2026-02-12', 32900);

-- Grant permisos de solo lectura
GRANT SELECT ON manzanaverde_test.* TO 'mv_readonly'@'%';
FLUSH PRIVILEGES;
