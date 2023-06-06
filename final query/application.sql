CREATE USER IF NOT EXISTS "application"@"localhost" IDENTIFIED BY "$app!";
GRANT ALL PRIVILEGES ON collectors.* TO 'application'@'localhost';