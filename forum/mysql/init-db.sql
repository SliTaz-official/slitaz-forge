--- Create DB and DB User for slitaz forum
---

USE Mysql;
CREATE DATABASE slitaz_forum;

GRANT ALL PRIVILEGES ON slitaz_forum.* TO slitaz IDENTIFIED BY 'slitaz';


