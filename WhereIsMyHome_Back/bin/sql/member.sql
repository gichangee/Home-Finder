
-- 칼럼에 권한레벨 추가        
ALTER TABLE ssafyhome.users
ADD COLUMN permission_level INT DEFAULT 1;


insert into ssafyhome.users (permission_level,user_id, user_name, user_password, email_id, email_domain, join_date)
values  (1,'ssafy', '김싸피', '1234', 'ssafy', 'ssafy.com', now()), 
        (0,'admin', '관리자', '1234', 'admin', 'google.com', now());

use ssafyhome;
select * 
from users;


insert into ssafyhome.board (user_id, subject, content)
values ('ssafy',' test article', 'test');
insert into ssafyhome.board (user_id, subject, content)
values ('ssafy',' 기창이 메롱', '^ㅗ^');
insert into ssafyhome.board (user_id, subject, content)
values ('ssafy',' test article', 'test');
select *
from board;


		SELECT COUNT(*) > 0
		from members
		where user_password = "0356" and user_id = "dpqls0356";


alter table users
add column token varchar(1000)
null default null after join_date;