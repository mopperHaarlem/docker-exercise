CREATE DATABASE testDB;

USE testDB;

CREATE TABLE `log_message_create_request` (  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL);

INSERT INTO log_message_create_request(reason) VALUES('created by creation of Container');

