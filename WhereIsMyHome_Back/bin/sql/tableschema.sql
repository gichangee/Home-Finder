CREATE database ssafyhome;
use ssafyhome;

CREATE TABLE `users` (
	`user_id` VARCHAR(16) NOT NULL,
	`user_name` VARCHAR(20) NOT NULL,
	`user_password` VARCHAR(100) NOT NULL,
	`email_id` VARCHAR(20) NULL,
	`email_domain` VARCHAR(45) NULL,
	`join_date` TIMESTAMP NOT NULL,
	PRIMARY KEY (`user_id`)
);

CREATE TABLE `board` (
	`article_no` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`user_id` VARCHAR(16) NULL,
	`subject` VARCHAR(100) NULL,
	`content` VARCHAR(2000) NULL,
	`hit` INT NULL DEFAULT '0',
	`register_time` TIMESTAMP NOT NULL
);

CREATE TABLE `dongcode` (
	`dongCode` VARCHAR(10) NOT NULL,
	`sidoName` VARCHAR(30) NULL,
	`gugunName` VARCHAR(30) NULL,
	`dongName` VARCHAR(30) NULL,
	PRIMARY KEY (`dongCode`)
);

CREATE TABLE `houseinfo` (
	`aptCode` BIGINT NOT NULL,
	`buildYear` INT NULL,
	`roadName` VARCHAR(40) NULL,
	`roadNameBonbun` VARCHAR(5) NULL,
	`roadNameBubun` VARCHAR(5) NULL,
	`roadNameSeq` VARCHAR(2) NULL,
	`roadNameBasementCode` VARCHAR(1) NULL,
	`roadNameCode` VARCHAR(7) NULL,
	`dong` VARCHAR(40) NULL,
	`bonbun` VARCHAR(4) NULL,
	`bubun` VARCHAR(4) NULL,
	`sigunguCode` VARCHAR(5) NULL,
	`eubmyundongCode` VARCHAR(5) NULL,
	`dongCode` VARCHAR(10) NULL,
	`landCode` VARCHAR(1) NULL,
	`apartmentName` VARCHAR(40) NULL,
	`jibun` VARCHAR(10) NULL,
	`lng` VARCHAR(30) NULL,
	`lat` VARCHAR(30) NULL,
	PRIMARY KEY (`aptCode`),
	FOREIGN KEY (`dongCode`) REFERENCES `dongcode` (`dongCode`)
);

CREATE TABLE `housedeal` (
	`no` BIGINT NOT NULL,
	`dealAmount` VARCHAR(20) NULL,
	`dealYear` INT NULL,
	`dealMonth` INT NULL,
	`dealDay` INT NULL,
	`area` VARCHAR(20) NULL,
	`floor` VARCHAR(4) NULL,
	`cancelDealType` VARCHAR(1) NULL,
	`aptCode` BIGINT NULL,
	PRIMARY KEY (`no`),
	FOREIGN KEY (`aptCode`) REFERENCES `houseinfo` (`aptCode`)
);

CREATE TABLE `comment` (
	`article_no` INT NOT NULL,
	`aptCode` BIGINT NOT NULL,
	`comment` VARCHAR(1000) NOT NULL,
	`user_id` VARCHAR(16) NOT NULL,
	PRIMARY KEY (`article_no`, `aptCode`, `user_id`),
	FOREIGN KEY (`article_no`) REFERENCES `board` (`article_no`),
	FOREIGN KEY (`aptCode`) REFERENCES `houseinfo` (`aptCode`),
	FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);

CREATE TABLE `highlightedproperty` (
	`Key` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`user_id` VARCHAR(16) NOT NULL,
	`aptCode` BIGINT NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
	FOREIGN KEY (`aptCode`) REFERENCES `houseinfo` (`aptCode`)
);

-- 수정사항
ALTER TABLE `board`
MODIFY COLUMN `register_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `board` ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`);

