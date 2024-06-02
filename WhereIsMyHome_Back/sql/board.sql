use ssafyhome;

-- 안전한 업데이트 모드 비활성화 - 세션 종료 시 활성화 된다.
SET SQL_SAFE_UPDATES=0;


delete from board;

-- 게시판 구분을 위한 칼럼 추가
ALTER TABLE board
ADD article_type INT NOT NULL;

-- 0 자유게시판 , 1qna 제약조건 추가
ALTER TABLE board
ADD CONSTRAINT chk_article_type
CHECK (article_type IN (0, 1));

-- 자유게시판
insert into ssafyhome.board (user_id, subject, content,article_type)
values ('ssafy',' test article', 'test',0);
insert into ssafyhome.board (user_id, subject, content,article_type)
values ('ssafy',' 기창이 메롱', '^ㅗ^',0);
insert into ssafyhome.board (user_id, subject, content,article_type)
values ('ssafy','매운갈비 .. 먹고싶따 ... ', 'ㅠ.. 5월 9일에 먹어야했는데 ...',0);

-- 공지사항
insert into ssafyhome.board (user_id, subject, content,article_type)
values ('ssafy','궁금해요.. 데이터 업데이트 해줘...', '야 ! 왜 데이터 업데이트 안함 ? 관리자 일 안하냐 ?',1);


select *
from review;





CREATE TABLE review (
	review_no int primary key auto_increment,
    subject VARCHAR(100),
    apartmentName varchar(40),
    content VARCHAR(10000),
    user_id VARCHAR(16),
    aptCode BIGINT,
    star INT,
    hit int DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (aptCode) REFERENCES houseinfo(aptCode)
);

insert into review(subject,apartmentName,content,user_id,aptCode,star,hit)
values("제목입닏,","청운현대","내영이빈다",'ssafy',11110000000042,5,0);

-- 리뷰에 등록일 추가
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE review ADD COLUMN register_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
delete from review;


INSERT INTO review (subject, apartmentName, content, user_id, aptCode, star, hit) 
VALUES 
('Great Place', '신천', 'Loved the location and amenities.', 'ssafy', 29155000000010, 5, 123),
('Good Value', '신천', 'Affordable and convenient.', 'ssafy', 29155000000010, 4, 98),
('Decent Experience', '신천', 'The apartment was okay, but had some issues.', 'ssafy', 29155000000010, 3, 56),
('Not Satisfied', '신천', 'Too noisy and the maintenance is poor.', 'ssafy', 29155000000010, 2, 34),
('Terrible Service', '신천', 'Very bad experience. Would not recommend.', 'ssafy', 29155000000010, 1, 21);

desc users;

select * from users;

SELECT * FROM users where email_id="dpqls0356123" and email_domain= "gmail.com";