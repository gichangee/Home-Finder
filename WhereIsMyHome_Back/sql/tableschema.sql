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
	`register_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`)
   
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


use ssafyhome;

-- 칼럼에 권한레벨 추가        
ALTER TABLE ssafyhome.users
ADD COLUMN permission_level INT DEFAULT 1;

ALTER TABLE users
ADD CONSTRAINT chk_permission_level
CHECK (permission_level IN (0, 1));

insert into ssafyhome.users (permission_level,user_id, user_name, user_password, email_id, email_domain, join_date)
values  (1,'ssafy', '김싸피', '1234', 'ssafy', 'ssafy.com', now());

insert into ssafyhome.users (permission_level,user_id, user_name, user_password, email_id, email_domain, join_date)
values (0,'admin', '관리자', '1234', 'admin', 'google.com', now());


alter table users
add column token varchar(1000) null default null after join_date;

CREATE TABLE review (
	review_no int primary key auto_increment,
    subject VARCHAR(100),
    apartmentName varchar(40),
    content VARCHAR(10000),
    user_id VARCHAR(16),
    aptCode BIGINT,
    star INT,
    hit int DEFAULT 0,
    `register_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (aptCode) REFERENCES houseinfo(aptCode)
);

insert into review(subject,apartmentName,content,user_id,aptCode,star,hit)
values("제목입니다","청운현대","내용입니다",'ssafy',11110000000042,5,0);


-- 버스 정류장 pk 설정
ALTER TABLE busstop MODIFY no VARCHAR(255);
ALTER TABLE busstop ADD PRIMARY KEY (no);

-- 게시판 구분을 위한 칼럼 추가
ALTER TABLE board
ADD article_type INT NOT NULL;

-- 0 자유게시판 , 1qna 제약조건 추가
ALTER TABLE board
ADD CONSTRAINT chk_article_type
CHECK (article_type IN (0, 1));
